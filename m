Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab2HGMNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 08:13:34 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:48480 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430Ab2HGMNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 08:13:31 -0400
MIME-Version: 1.0
In-Reply-To: <1344308038.1682.637.camel@rui.sh.intel.com>
References: <1344308038.1682.637.camel@rui.sh.intel.com>
Date: Tue, 7 Aug 2012 17:43:30 +0530
Message-ID: <CAK44p22ewPR2h_KLqHjmNY4KVG-E68s5BxdUXrzRy_hk4Nf7Cg@mail.gmail.com>
Subject: Re: thermal patches in linux-next
From: Amit Kachhap <amit.kachhap@linaro.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        guenter.roeck@ericsson.com, kuninori.morimoto.gx@renesas.com,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks Rui for creating the next tree. I will rebase my patches on top
of your tree and post them shortly.

Thanks,
Amit Daniel

On 7 August 2012 08:23, Zhang Rui <rui.zhang@intel.com> wrote:
> Hi, all,
>
> I just created a git tree for catching all thermal changes.
> http://git.kernel.org/?p=linux/kernel/git/rzhang/linux.git;a=summary
> and I also created the next branch, which I'd like to be set for
> linux-next inclusion, but don't know how.
>
> And, I just saw that there are a couple of thermal patches in
> linux-next, which I think it would be better if they can be re-based on
> my next branch first.
> For Guenter's and Kuninori's patch, I can take them directly, with few
> changes.
>
> Amit,
> I really like the idea of generic cpufreq cooling. But can you please
> rebase the patches on top of my next branch? the recent thermal changes
> will make your patch much cleaner, as we discussed before. :)
>
> thanks,
> rui
>
