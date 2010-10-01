Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656Ab0JANYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 09:24:41 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:32936 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932462Ab0JANYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 09:24:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=h6yyeRgczyy4zou9/ragXARjz5Ko1HvyRZ7pwmeJUrad6Fo8dHzzzZkQPckcEvwtlh
         Ht1SS7HJ2T5bPEJtQpVrEkOvFylK+H5VXj2AZdL1hyGhJVtSu/U1foi/HT38yrGn78vz
         dWE3oYmQuc8WPxYwaOigAfMHDwxAepVZlgmr0=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=4Eb+_1MTQtic3y5Wfn+i6dYgJrqtFYwAHVGGT@mail.gmail.com>
References: <AANLkTi=NFz95jvk73cgXGV-kzj7FFazgMJ6D+GOXr3Kb@mail.gmail.com>
	<006201cb6048$962b6810$c2823830$%kim@samsung.com>
	<AANLkTimb02EB+G2eV2dEcL8Fc7EJitgvshWYMawuzgOx@mail.gmail.com>
	<AANLkTi=4Eb+_1MTQtic3y5Wfn+i6dYgJrqtFYwAHVGGT@mail.gmail.com>
Date: Fri, 1 Oct 2010 22:19:36 +0900
X-Google-Sender-Auth: p37TsbkGy8KtsaSN7FQNz9wZmvQ
Message-ID: <AANLkTikuST8L2k4Si2j=KnvWL=FZhuCwFsw+KSYbU5k5@mail.gmail.com>
Subject: Re: Please don't edit the subject. Use S5PC110 & S5PC210 as is
From: Kyungmin Park <kmpark@infradead.org>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Fujak <t.fujak@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        arm-linux <linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 12:47 PM, Jassi Brar <jassisinghbrar@gmail.com> wrote:
> On Thu, Sep 30, 2010 at 11:53 AM, Kyungmin Park <kmpark@infradead.org> wrote:
>> On Thu, Sep 30, 2010 at 11:38 AM, Kukjin Kim <kgene.kim@samsung.com> wrote:
>>> Kyungmin Park wrote:
>>>>
>>>> Hi,
>>>>
>>>> Please don't edit the subject.
>>>>
>>>> http://git.kernel.org/?p=linux/kernel/git/kgene/linux-
>>>> samsung.git;a=commitdiff;h=d8c3d96f5df54251c06686bb00811e4b7e0f6547
>>>> http://git.kernel.org/?p=linux/kernel/git/kgene/linux-
>>>> samsung.git;a=commitdiff;h=7dcde8f18b0df4d332d6b359fd6270772a42f71f
>>>>
>>>> Patches from DMC we decide to use the S5PC110 & S5PC210 as we're only
>>>> received the Spec C110 & C210.
>>>> Most of people including mobile division don't know the V210 & V310
>>>> SOC receptively.
>>>>
>>>> We're already confusing with names, we always talk with C110 & C210
>>>> but works on V210 & V310 directory.
>>>>
>>>> well question. What's the SOC is used at Galaxy S & wave phone?
>>>>
>>>> I think S5PC110 is more well known than S5PV210.
>>>>
>>>> http://lwn.net/Articles/399720/
>>>> The conclusion of the 2.6.36 merge window
>>>> Systems and processors: Income s.r.o. PXA270 single-board computers,
>>>> Wiliboard WBD-111 boards, and Samsung S5PC210-based systems.
>>>>
>>>> Thank you,
>>>> Kyungmin Park
>>>
>>> As I'm a maintainer of Samsung S5P SoCs, I would like to use second column
>>> in the subject line to indicate the ARCH_XXX name like following.
>>> 'ARM: S5PV210: <patch subject>'
>>> As you know, it means the patch is mainly regarding ARCH_S5PV210
>>> (arch/arm/mach-s5pv210/).
>>>
>>> It can be help to many people, including me that the title speak where it
>>> belong to.
>>>
>>> And I believe someone who can use git log to see the log and source, S5PC110
>>> is in the 'arch/arm/mach-s5pv210/'.
>>
>> Right, many people are confused where's the s5pc110 codes? and know
>> it's under mach-s5pv210.
>> And finally know it's almost same S5PC110 = S5PV210 so if it use the
>> S5PC110 at subject. not issue.
>
> People will be confused to see S5PC110/C210 in subject line, when
> apparently there is no such machine in the kernel.
> The decision time was when we moved C110 -> V210 and C210 -> V310
> No point invoking the dead, let us move one.
>
Who's "we"? I think it's just decision from LSI side.
Do you heard or talked with mobile division person with V210 & V310?
At least DMC & Mobile I don't see the V210 & V310 at any documents and heard.
All documents and reports are written with C110 & C210.
It's best that send the V210 & V310 User Manual to mobile division and
ask for that use the V210 & V310 officially.

Than this problem will be solved.

Thank you,
Kyungmin Park
