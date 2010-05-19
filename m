Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab0ESLFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 07:05:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46524 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248Ab0ESLFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 07:05:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ifZzlSUl4r++EWH/nZmHBoqpnvi7IfeV2K8ReAadV80eHYssDgqrjfkGBtl1TdBzbg
         Qya+BY8HCnKZYmeyi82xIs+7bTQqgmNwnX91jLBqW6eZWOZnw9EQ5/74K/Eaaeg4XIy5
         SyCy5ewwX2lJVJ/RKJGeMZCbHhbWZB4FK4RvE=
MIME-Version: 1.0
In-Reply-To: <AANLkTil73ArhX2w6b_v1bmWjP1FA5zUTfPzK2N4waOu1@mail.gmail.com>
References: <AANLkTil73ArhX2w6b_v1bmWjP1FA5zUTfPzK2N4waOu1@mail.gmail.com>
Date: Wed, 19 May 2010 14:05:07 +0300
Message-ID: <AANLkTik0IjrVr-Cey0wumA5DpL5XutUwEtnp_1w2OQEY@mail.gmail.com>
Subject: Re: [ANNOUNCE] GSoC project: Improving kconfig using a SAT solver
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Bart Massey <bart@cs.pdx.edu>, Michal Marek <mmarek@suse.cz>,
       Greg Kroah-Hartman <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 3:02 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> Hi,
>
> I just wanted to say that I've been accepted into this year's Google
> Summer of Code program and will spend this summer working on improving
> the kconfig system in a very particular direction: I want to integrate
> a proper boolean constraint satisfiability solver into the
> configuration editors (menuconfig, etc.) in order to allow
> partial/incomplete configuration specifications. In short, this means
> that the user can choose to not specify a particular value for some
> config options, but let the system deduce their values. This will
> hopefully improve usability and also solve the select problem once and
> for all.
>
> A slightly shortened version of the project proposal that was accepted
> can be found here:
>
> http://userweb.kernel.org/~vegard/gsoc2010/proposal-short.html
>
> In case anybody would like to track my progress throughout the summer,
> I have set up my public project repositories at:
>
> http://github.com/vegard/dpll
> http://github.com/vegard/linux-2.6-kconfig-sat
>
> I am also planning to post some updates to LKML as milestones are
> completed.  (Please let me know if you would like to be added to or
> removed from the Cc list.) The official end date is August 16, by
> which time I hope to have submitted my work for mainline inclusion.
>
> Feedback is appreciated -- I am also prepared to respond to
> constructive criticism.
>
> Lastly, I would like to thank Google for sponsoring me, and to thank
> Portland State University and my mentor Bart Massey for believing in
> this idea and project.

Very nice! I thought on this idea too.

Does this means that if you have a pristine kernel, and you do 'make
menuconfig' and don't change anything, the .config file will be empty?
And then, anything that you change will be in the .config file?

On another case I do 'make ARCH=arm omap3_beagle_defconfig' then my
.config file will point to that particular defconfig, and I can add
only the changes that I want. Also, omap3_beagle_defconfig probably
points omap3_defconfig and only makes certain changes.

If so, that would be awesome :)

-- 
Felipe Contreras
