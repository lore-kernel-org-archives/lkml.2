Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab1BDVGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 16:06:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47711
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752235Ab1BDVGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 16:06:06 -0500
Date: Fri, 04 Feb 2011 13:06:41 -0800 (PST)
Message-Id: <20110204.130641.189714870.davem@davemloft.net>
To: segoon@openwall.com
Cc: linux-kernel@vger.kernel.org, security@kernel.org, wg@grandegger.com,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org
Subject: Re: [PATCH 13/20] net: can: janz-ican3: world-writable sysfs
 termination file
From: David Miller <davem@davemloft.net>
In-Reply-To: <6b49b9521416fbd50214485d3e14e5f254ada4f7.1296818921.git.segoon@openwall.com>
References: <cover.1296818921.git.segoon@openwall.com>
	<6b49b9521416fbd50214485d3e14e5f254ada4f7.1296818921.git.segoon@openwall.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segoon@openwall.com>
Date: Fri,  4 Feb 2011 15:23:53 +0300

> Don't allow everybody to set terminator via sysfs.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

Applied.
