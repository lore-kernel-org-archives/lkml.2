Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab1KVTeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 14:34:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48585 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623Ab1KVTea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 14:34:30 -0500
Message-ID: <4ECBF979.1000903@suse.cz>
Date: Tue, 22 Nov 2011 20:35:21 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Dave Martin <dave.martin@linaro.org>
Cc: Alessandro Rubini <rubini@unipv.it>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] ARM: amba: Enable module alias autogeneration for
 AMBA drivers
References: <20111122120756.GF2066@localhost.localdomain> <1321961573-4562-1-git-send-email-dave.martin@linaro.org> <20111122115632.GA5165@mail.gnudd.com> <20111122151942.GA24821@mail.gnudd.com> <20111122183408.GI2066@localhost.localdomain>
In-Reply-To: <20111122183408.GI2066@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 22.11.2011 19:34, Dave Martin napsal(a):
> On Tue, Nov 22, 2011 at 04:19:42PM +0100, Alessandro Rubini wrote:
>>>>   lkml.org/lkml/2011/11/4/125 (0/2: description of the work)
>>>>   lkml.org/lkml/2011/11/4/126 (1/2: turn the if plethora to table lookup)
>>>>   lkml.org/lkml/2011/11/4/127 (2/2: partial split to type-specific files).
>>>
>>> Splitting this up doesn't look like a silly idea -- I thought it was
>>> unfortunate to have to patch a core file just to add a bus type.
>>>
>>> I guess the question is how many new buses we get over time.
>>
>> Well, CERN will have 2 in a short time. And I'm sure the bus concept
>> is so good that a number of them exists as external patches. Being
>> forced to patch a core file is not good, with conflicts that accumulate
>> over time.
>>
>> I'd better be able to drop in my own file and add a kconfig-aware line
>> in Makefile.  I think the implementation is straightforward. Who should
>> I send it to?
> 
> I'm afraid I can't help there -- I don't often dabble in core kernel stuff.
> 
> I didn't receive any response on my patches to those files, so it's possible
> I was CC'ing the wrong people.  I did do my best dith git blame/log,
> get_maintainer.pl and the rest and posted to lkml a couple of times though.

Sorry, I saw your patch, but didn't have time to look at it more closely.

> 
> If I'm reading MAINTAINERS correctly, Michal Marek might be the default
> maintainer for stuff in scripts/ not owned by other people... the way that
> is described is not understood by get_maintainer.pl, it appears.
> 
> Marek, are you the correct person for scripts/mod/file2alias.c and related
> stuff?

Me (default scripts/ suspect) or Rusty (modules maintainer). But people
usually add an alias generator for their bus and don't ask anyone :).
And I don't mind, because the changes tend to be no-brainers. That said,
Alessandro's split of file2alias.c looks interesting. Please CC Rusty
and me in the next iteration.

Michal
