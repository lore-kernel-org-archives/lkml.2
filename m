Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab1CPT4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 15:56:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56713 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753528Ab1CPT4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 15:56:34 -0400
Date: Wed, 16 Mar 2011 19:56:32 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>, davidb@codeaurora.org,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Collins <collinsd@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Linus Walleij <linux.walleij@sterricsson.com>,
        Thomas Glexiner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Qualcomm PM8921 MFD v2 3/6] gpio: pm8xxx-gpio: Add pm8xxx
 gpio driver
Message-ID: <20110316195631.GD15605@opensource.wolfsonmicro.com>
References: <1299564590-30116-1-git-send-email-adharmap@codeaurora.org>
 <1299564590-30116-4-git-send-email-adharmap@codeaurora.org>
 <20110312093645.GL9347@angua.secretlab.ca>
 <4D810797.4090000@codeaurora.org>
 <20110316195444.GB4000@angua.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110316195444.GB4000@angua.secretlab.ca>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 01:54:44PM -0600, Grant Likely wrote:

> Yes, remove the comment.  I'll probably also remove the comment for
> MODULbus and AC97.

In theory there should be more AC'97 GPIO drivers - at least the wm97xx
chips have GPIOs (currently supported by a custom API).  I'm not sure if
anyone will ever have sufficient time and enthusiasm to move them over
to gpiolib, though.
