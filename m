Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab1ANAYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 19:24:46 -0500
Received: from one.firstfloor.org ([213.235.205.2]:32986 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab1ANAYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 19:24:39 -0500
Date: Fri, 14 Jan 2011 01:24:35 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: Re: [PATCH] oprofile: Add support for missing Intel core i7 models
Message-ID: <20110114002435.GR25713@one.firstfloor.org>
References: <1294958291-5626-1-git-send-email-sbohrer@rgmadvisors.com> <20110113235503.GY4739@erda.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110113235503.GY4739@erda.amd.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 12:55:03AM +0100, Robert Richter wrote:
> On 13.01.11 17:38:11, Shawn Bohrer wrote:
> > Added missing core i7 models found in "Intel 64 and IA-32 Architectures
> > Software Developer's Manual Volume 3B: System Programming Guide",
> > Table B-1.  Tested with oprofile 0.9.6 on a:
> > 
> > model      : 44
> > model name : Intel(R) Xeon(R) CPU           X5680  @ 3.33GHz
> > 
> > Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
> 
> Andi,
> 
> please ACK.

NACK -- first it's wrong because that's a westmere and westmere
has a different event list. And the new way is to fall back to arch-perfmon
and handle the CPUID in user space. This has been already implemented.
So the fix is to upgrade user space.

-Andi
