Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab0IFIyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 04:54:44 -0400
Received: from smtprelay03.ispgateway.de ([80.67.31.37]:45112 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab0IFIyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 04:54:44 -0400
Message-ID: <4C84AC6B.8000702@ladisch.de>
Date: Mon, 06 Sep 2010 10:55:07 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
CC: "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] HPET: Supporting info for hpet_example
References: <AANLkTimFNum+dPcb6+UWFSm-Urr9mYnVMypOQahCfnhg@mail.gmail.com>
In-Reply-To: <AANLkTimFNum+dPcb6+UWFSm-Urr9mYnVMypOQahCfnhg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> $./hpet_example info /dev/hpet
> -hpet: executing info
> hpet_info: hi_irqfreq 0x0 hi_flags 0x0 hi_hpet 0 hi_timer 2

The interrupt frequency is always zero before the application has set
it, so it doesn't make much sense to show it in this function.


Regards,
Clemens
