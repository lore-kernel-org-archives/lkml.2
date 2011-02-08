Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab1BHJvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 04:51:41 -0500
Received: from smtprelay04.ispgateway.de ([80.67.31.31]:44575 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab1BHJvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 04:51:40 -0500
Message-ID: <4D511268.5040804@ladisch.de>
Date: Tue, 08 Feb 2011 10:52:40 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: dave b <db.pub.mail@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: I do not know if this is the correct place to ask about this
 but...
References: <AANLkTi=1wjdu3kT6nimU0fnZStG01a57D3O5Up+oJRdr@mail.gmail.com>
In-Reply-To: <AANLkTi=1wjdu3kT6nimU0fnZStG01a57D3O5Up+oJRdr@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dave b wrote:
> I do not know if this is the correct place to ask about this but...
> 
> [Hardware Error]:

This is a hardware error that was detected by the kernel.

> I have only seen the following output output twice
> 
> ... Corrected error
> ... L3 ECC data cache error.

There was a wrong bit in your CPU's level 3 cache, but with the help of
the redundant error correction bits, this was caught and corrected.

(If possible, enable background scrubbing of the caches in the BIOS ECC
settings to catch these errors earlier.)

If this is an overclocked CPU or one with an unlocked core, you deserve
what you got.  Otherwise, if this happens repeatedly, it indicates
a hardware defect, and your warranty should cover this.


Regards,
Clemens
