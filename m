Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab0K2C0L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 21:26:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54485
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754347Ab0K2C0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 21:26:10 -0500
Date: Sun, 28 Nov 2010 18:26:35 -0800 (PST)
Message-Id: <20101128.182635.59677769.davem@davemloft.net>
To: scottjg@vmware.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, pv-drivers@vmware.com,
        randy.dunlap@oracle.com
Subject: Re: [PATCH] vmxnet3: fix compilation when RSS is disabled
From: David Miller <davem@davemloft.net>
In-Reply-To: <1290890035-32285-2-git-send-email-scottjg@vmware.com>
References: <1290890035-32285-1-git-send-email-scottjg@vmware.com>
	<1290890035-32285-2-git-send-email-scottjg@vmware.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Scott J. Goldman" <scottjg@vmware.com>
Date: Sat, 27 Nov 2010 12:33:55 -0800

> If RSS is disabled, we can ifdef out some RSS specific code. This fixes
> the compile error found by Randy Dunlap.
> 
> Signed-off-by: Scott J. Goldman <scottjg@vmware.com>

Applied.
