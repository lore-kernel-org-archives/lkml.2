Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760387Ab0KRUoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:44:14 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55980 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760265Ab0KRUoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:44:13 -0500
Date: Thu, 18 Nov 2010 13:44:10 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: David Miller <davem@davemloft.net>
Cc: ddaney@caviumnetworks.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] phylib: Add support for Marvell 88E1149R devices.
Message-ID: <20101118204410.GB16908@angua.secretlab.ca>
References: <1290038071-13296-1-git-send-email-ddaney@caviumnetworks.com>
 <1290038071-13296-3-git-send-email-ddaney@caviumnetworks.com>
 <20101118.114616.258106719.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118.114616.258106719.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 11:46:16AM -0800, David Miller wrote:
> From: David Daney <ddaney@caviumnetworks.com>
> Date: Wed, 17 Nov 2010 15:54:31 -0800
> 
> > The 88E1149R is 10/100/1000 quad-gigabit Ethernet PHY.  The
> > .config_aneg function can be shared with 88E1118, but it needs its own
> > .config_init.
> > 
> > Signed-off-by: David Daney <ddaney@caviumnetworks.com>
> 
> Please resend this when you've respun patch #1 based upon the feedback
> you've been given.

It looks to me that this patch has no dependencies on the first patch.
ddaney; what say you?

g.
