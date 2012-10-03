Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab2JCILE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 04:11:04 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55745 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab2JCIK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 04:10:59 -0400
MIME-Version: 1.0
In-Reply-To: <72a0df374d6e1da3b55071030e38354f7d64b604.1348854133.git.viresh.kumar@linaro.org>
References: <72a0df374d6e1da3b55071030e38354f7d64b604.1348854133.git.viresh.kumar@linaro.org>
Date: Wed, 3 Oct 2012 13:40:58 +0530
Message-ID: <CAKohpokxWcL_bAgZubRsCqEr_aEm=ztZjx0qaMZ980NLMxg7gg@mail.gmail.com>
Subject: Re: [RFC] timer: Migrate running timer
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de, linux-kernel@vger.kernel.org
Cc: pjt@google.com, paul.mckenney@linaro.org, tj@kernel.org,
        suresh.b.siddha@intel.com, venki@google.com, mingo@redhat.com,
        peterz@infradead.org, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Arvind.Chauhan@arm.com, amit.kucheria@linaro.org,
        vincent.guittot@linaro.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 September 2012 23:14, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> I haven't tested it much till now. I am sending this patch just to check if the
> initial idea looks fine to you guys or not.

Tested with:
- ARM Vexpress TC2 - big.LITTLE CPU
- Core 0-1: A15, 2-4: A7
- rootfs: linaro-ubuntu-nano

and following test module

http://git.linaro.org/gitweb?p=people/vireshk/module.git;a=summary

--
viresh
