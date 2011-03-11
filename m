Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab1CKT5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 14:57:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55560 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751677Ab1CKT5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 14:57:21 -0500
Date: Fri, 11 Mar 2011 19:57:19 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>, davidb@codeaurora.org,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Collins <collinsd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Linus Walleij <linus.walleij@sterricsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Qualcomm PM8921 MFD v2 2/6] mfd: pm8xxx: Add irq support
Message-ID: <20110311195719.GX1760@opensource.wolfsonmicro.com>
References: <1299564590-30116-1-git-send-email-adharmap@codeaurora.org>
 <1299564590-30116-3-git-send-email-adharmap@codeaurora.org>
 <alpine.LFD.2.00.1103081201520.2787@localhost6.localdomain6>
 <4D770E47.6050402@codeaurora.org>
 <alpine.LFD.2.00.1103101126100.2787@localhost6.localdomain6>
 <4D79A85D.8000301@codeaurora.org>
 <alpine.LFD.2.00.1103111853480.2787@localhost6.localdomain6>
 <4D7A71B9.9000306@codeaurora.org>
 <alpine.LFD.2.00.1103112020370.2787@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103112020370.2787@localhost6.localdomain6>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 08:43:08PM +0100, Thomas Gleixner wrote:

> Sigh, why insist people on working around core code instead of talking
> to the responsible maintainers about their problem in the first place?

I don't know if it's the case here but with a lot of the people I speak
to it's because they're used to working on proprietary OSs where there's
no possibility of fixing the core and they haven't yet realised that
this is a possibility.
