Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645Ab0KRTpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 14:45:52 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59200
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754438Ab0KRTpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 14:45:51 -0500
Date: Thu, 18 Nov 2010 11:46:16 -0800 (PST)
Message-Id: <20101118.114616.258106719.davem@davemloft.net>
To: ddaney@caviumnetworks.com
Cc: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] phylib: Add support for Marvell 88E1149R devices.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1290038071-13296-3-git-send-email-ddaney@caviumnetworks.com>
References: <1290038071-13296-1-git-send-email-ddaney@caviumnetworks.com>
	<1290038071-13296-3-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <ddaney@caviumnetworks.com>
Date: Wed, 17 Nov 2010 15:54:31 -0800

> The 88E1149R is 10/100/1000 quad-gigabit Ethernet PHY.  The
> .config_aneg function can be shared with 88E1118, but it needs its own
> .config_init.
> 
> Signed-off-by: David Daney <ddaney@caviumnetworks.com>

Please resend this when you've respun patch #1 based upon the feedback
you've been given.

Thanks.
