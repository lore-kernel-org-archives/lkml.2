Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533Ab2L1HgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 02:36:25 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:42555 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab2L1HgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 02:36:22 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: anish singh <anish198519851985@gmail.com>
Cc: amit mehta <gmate.amit@gmail.com>,
        Henrique Rodrigues <henriquesilvar@gmail.com>,
        kishore kumar <kishoreopen@gmail.com>,
        Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        linux-kernel@vger.kernel.org, Kernelnewbies@kernelnewbies.org
References: <CA+8YGd6UqfbzEHOb2NUL5p3EF4OECVq7yc2vRV3GViVT64CTbQ@mail.gmail.com>
	<20121227184034.GA2982@debian.debian>
	<CABuSbKbk5DdhvuwYUeLkm=eub1CsSaOB_oX7bkBZcAV_MNsSdg@mail.gmail.com>
	<CAK7N6vpvLrAb=sZitaEBQ6Fx4K5ehGg+LTU70hiVK=1RdE4WwQ@mail.gmail.com>
	<CAOUxTKNgs4N-M5RR6YHyGeXQqRrg0_CJpxgT2OmN_buEP+jbjQ@mail.gmail.com>
	<CAK7N6vqw+DVSVaCXqiQBVa_d2o-rg-oA5t8+6WNaZ9Mb_iQqdw@mail.gmail.com>
Date: Thu, 27 Dec 2012 23:36:13 -0800
In-Reply-To: <CAK7N6vqw+DVSVaCXqiQBVa_d2o-rg-oA5t8+6WNaZ9Mb_iQqdw@mail.gmail.com>
	(anish singh's message of "Fri, 28 Dec 2012 10:49:00 +0530")
Message-ID: <87a9syhbma.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18iDjYpaR9rpBOYmmCd2J75m+HqEd93Gs8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0123]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;anish singh <anish198519851985@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: how to look for source code in kernel
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

anish singh <anish198519851985@gmail.com> writes:

> On Fri, Dec 28, 2012 at 10:42 AM, amit mehta <gmate.amit@gmail.com> wrote:
>>>>> On Thu, Dec 27, 2012 at 11:01:52PM +0530, kishore kumar wrote:
>>>>> > can anybody tell me how to look into source code, as most are hidden in
>>>>> > kernel.
>>>>>
>>>>> You can find the Linux source code at http://kernel.org/ .
>>> for browsing the code unfortunately there is no good tool as in windows we
>>> have source insight.We can use wine in linux but that sucks.
>> Funny you say that!
>> Never heard of cscope, ctags ?
> It is not as convenient as source insight or is it?

I took a look and source insite seems to have a whole lot of
inconvinient mousing around.  A setup where you get to stay on your home
keys seems much more convinient to me.

But then I am probably peculiar keeping an index of the source code in
my head.  When I need to look for something and I don't know where to
find it I do.

git-ls-files | xargs fgrep 'struct f2fs_inode'

That returns instantly and tells me where to look.  If you can do an
instant brute force search what is the point of an index?

My experience with gui editors is that they always hide something I need
to see, or my code is just strange enough (say having asm file, or
supporting multiple architectures) that the tools get horribly confused.

So I suspect source insight would be terribly inconvinient to the point
of uselessness to me.

Eric
