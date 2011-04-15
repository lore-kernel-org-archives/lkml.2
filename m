Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab1DOFEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 01:04:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34177
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753748Ab1DOFEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 01:04:46 -0400
Date: Thu, 14 Apr 2011 22:04:11 -0700 (PDT)
Message-Id: <20110414.220411.183045866.davem@davemloft.net>
To: decot@google.com
Cc: fubar@us.ibm.com, andy@greyhouse.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] net-bonding: Adding support for throughputs larger
 than 65536 Mbps
From: David Miller <davem@davemloft.net>
In-Reply-To: <1302744151-12452-3-git-send-email-decot@google.com>
References: <1302744151-12452-1-git-send-email-decot@google.com>
	<1302744151-12452-3-git-send-email-decot@google.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Decotigny <decot@google.com>
Date: Wed, 13 Apr 2011 18:22:31 -0700

> This updates the bonding driver to support v2.6.27-rc3 enhancements
> (b11f8d8c aka. "ethtool: Expand ethtool_cmd.speed to 32 bits") which
> allow to encode the Mbps link speed on 32-bits (Max 4 Pbps) instead of
> 16 (Max 65536 Mbps).
> 
> This patch also attempts to compact struct slave by reordering its
> fields.
> 
> Signed-off-by: David Decotigny <decot@google.com>

Applied.
