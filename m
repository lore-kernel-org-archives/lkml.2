Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab2BHW6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 17:58:25 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:43888 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754828Ab2BHW6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 17:58:23 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH 01/50] eth: reset addr_assign_type if eth_mac_addr() called
Date: Wed, 8 Feb 2012 23:57:28 +0100
User-Agent: KMail/1.9.10
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de> <1328735457-29986-2-git-send-email-danny.kukawka@bisect.de> <20120208145004.171e4d54@nehalam.linuxnetplumber.net>
In-Reply-To: <20120208145004.171e4d54@nehalam.linuxnetplumber.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201202082357.28972.danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328741903;0d226a78;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mittwoch, 8. Februar 2012, Stephen Hemminger wrote:
> On Wed,  8 Feb 2012 22:10:08 +0100
>
> Danny Kukawka <danny.kukawka@bisect.de> wrote:
> > +	if (dev->addr_assign_type & NET_ADDR_RANDOM)
> > +		dev->addr_assign_type ^= NET_ADDR_RANDOM;
>
> Why not just avoid the conditional, or better yet use bitops?
>
> 	dev->addr_assign_type &= ~NET_ADDR_RANDOM;

Okay, If I have comments on the other patches back, I will send new versions 
which avoid the if. Thanks for the hint.

Danny

