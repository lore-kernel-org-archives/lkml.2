Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab2JJKdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 06:33:23 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:47048 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab2JJKdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 06:33:13 -0400
MIME-Version: 1.0
In-Reply-To: <20121010101747.GD3729@e103034-lin>
References: <1348252345-5642-1-git-send-email-morten.rasmussen@arm.com>
	<1348252345-5642-7-git-send-email-morten.rasmussen@arm.com>
	<CAKohponvN+-rBxeBW6L1UiwzuDLJ+zymzawyoT3PdxMB31vxRw@mail.gmail.com>
	<20121010101747.GD3729@e103034-lin>
Date: Wed, 10 Oct 2012 16:03:13 +0530
Message-ID: <CAKohpok5ESED8E_e+Jeu1vi9x9bagaHxDSiLDqsoP-ZW1RTFAg@mail.gmail.com>
Subject: Re: [RFC PATCH 06/10] ARM: sched: Use device-tree to provide
 fast/slow CPU list for HMP
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Morten Rasmussen <Morten.Rasmussen@arm.com>
Cc: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "pjt@google.com" <pjt@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        "linaro-sched-sig@lists.linaro.org" 
	<linaro-sched-sig@lists.linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Robin Randhawa <Robin.Randhawa@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 October 2012 15:47, Morten Rasmussen <Morten.Rasmussen@arm.com> wrote:
> On Thu, Oct 04, 2012 at 07:49:32AM +0100, Viresh Kumar wrote:

>> > This patch is reuse of a patch by Jon Medhurst <tixy@linaro.org> with a
>> > few bits left out.
>>
>> Then probably he must be the author of this commit? Also a SOB is required
>> from him here.
>>
>
> I don't know what the correct procedure is for this sort of partial
> patch reuse. Since I didn't know better, I adopted Tixy's own reference
> style that he used in one of his patches which is an extension of a
> previous patch by me. I will of course fix it to follow normal procedure
> if there is one.

AFAIK, if you have used only some part of the earlier patch, then you just
need to add an SOB of original author.
But if you have picked most of the stuff from original patch, which i feel is
the case here, you must have original author in author & SOB + your SOB.

> It would be very easy to blame someone else here... :) I will fix it.

:)
