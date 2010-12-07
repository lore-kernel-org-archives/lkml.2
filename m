Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab0LGJPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 04:15:47 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39614 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753113Ab0LGJPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 04:15:45 -0500
X-Sasl-enc: L3tWISYUUJNFMwym0lXIi754Z34EHZ78Tnt6rwWPTcM8 1291713343
Message-ID: <4CFDFBB0.8050804@ladisch.de>
Date: Tue, 07 Dec 2010 10:17:36 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux-kernel@vger.kernel.org,
        linux1394-devel <linux1394-devel@lists.sourceforge.net>
Subject: Re: Issue with firewire from 2.6.35.9 to 2.6.36.1
References: <1291592226.7134.1.camel@pheuri.wyrms.net>	<1291594279.9196.2.camel@maxim-laptop>	<20101206082918.6d1ccc41@stein>	<1291673087.4022.2.camel@pheuri.wyrms.net> <20101207092735.48b82c40@stein>
In-Reply-To: <20101207092735.48b82c40@stein>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> I wonder which of our options is preferable:
>   - Change fw-ohci from MSI blacklisting to whitelisting.  Agere FW643
>     rev 07 is the only chip that can be whitelisted.
>   - Simply drop MSI support altogether.

That depends on whether the maintainer can afford the effort of
maintaining the whitelist.


Regards,
Clemens
