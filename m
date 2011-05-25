Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab1EYUeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:34:01 -0400
Received: from smtp105.prem.mail.sp1.yahoo.com ([98.136.44.60]:30290 "HELO
	smtp105.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753334Ab1EYUeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:34:00 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: qoMA3KEVM1nys3dKgs21wImFlsEehRa8V3CpphOixLBCfP1
 Uf.Jqu_9RDmiskl7_4bvr1vWlhB4v_JEBXT8wza8qfEyARZAeM6sQwY.I5sR
 EiDLWH96GEBhMlZId_PMAdy74yxorAmCsVnXh6GnultOlODxevfNHUdSWoFh
 40rAyuN7MplInHM9S7h.vycEQ8EDnW_TAhRzSAw77r_cqsYA3fS1lmmrDuZz
 iQbShMPO0HytJDWFv4amFtEh_xinfUIwjYvgdjVmNueZybNPIjcFMCCRtGLI
 59WutwWa.ImTGc_BC_VzPI8h_MrCS5Yk8VEfDigVC5VmApeFwSRaMhkceSkQ
 tmKtJlPIcZfbD1ZiNa6G_i0Cp_t_qcvj1gxOFgwYqxXB6K8AmoPGJuury_ug
 fiMEMZvm9cgVc1p_kcS9w1Yuk6JtgKQ7L8IKDJGNuCTzR3_tQBMdXtFYgoNp
 2FTYUdy5bk_IWrFTNHhfZ
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4DDD67B4.5080803@schaufler-ca.com>
Date: Wed, 25 May 2011 13:33:56 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Michael Witten <mfwitten@gmail.com>
CC: "Ted Ts'o" <tytso@mit.edu>, Mike Galbraith <efault@gmx.de>,
        Richard Yao <ryao@ic.sunysb.edu>, linux-kernel@vger.kernel.org
Subject: Re: UNIX Compatibility
References: <BANLkTin4wu1HNDeo8Rv7iddM9KkgZdhfgA@mail.gmail.com>            <A7E21A2F-4338-465D-933A-66B0C4D15BE1@mit.edu>            <BANLkTi=q7tDVkahrnng7+BJhvxh=gx71ng@mail.gmail.com>            <20110524181619.GC26055@thunk.org>            <BANLkTi=QUS5WfAMWTw7vuEwuBOVHsww3mA@mail.gmail.com>            <1306297108.4819.28.camel@marge.simson.net>            <64e4614dda6f4558a68a314d7b5979b5-mfwitten@gmail.com>            <20110525143602.GE8476@thunk.org>            <c943132c8c364f95a91e3cf81cb0f2bd-mfwitten@gmail.com> <20110525173846.GG8476@thunk.org>
In-Reply-To: <20110525173846.GG8476@thunk.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/25/2011 11:51 AM, Michael Witten wrote:
> On Wed, 25 May 2011 13:38:46 -0400, Ted Ts'o wrote:
>
>> On Wed, May 25, 2011 at 03:17:35PM +0000, Michael Witten wrote:
>>
>>> The winner is not the one who smashes the competition; the winner is the
>>> one who best eases the lives of as many people as possible.
>>>
>>> The point of such a specification is to provide a single, relatively stable
>>> source of documentation for how a complex system works.
>> I've been to ISO standards meetings, and it is filled with people who
>> use standards for the purposes of gaining a competitive advantage.
>> Most of them were paid to do standards work by companies who funded it
>> precisely because it would net them a competitive advantage.
> That's great. Nobody is defending them; they certainly aren't the eggheads,
> and they clearly aren't inhabitants of any ivory tower.
>
> Essentially, your wrath is misdirected.
>
>>>> This idea that Linux needs to care about being "Unix compatible" keeps
>>>> coming back from the grave, like some Buffy-the-vampire-slayer
>>>> monster.  It's time to slay it.
>>> What needs to die is the tyranny of the hackers.
>>>
>>> Humans are capable of organizing themselves better than just acquiscing to
>>> whomever is capable of imposing himself fastest.
>> Oh, you wanted the new features that's in Linux?  The new hardware
>> support?  That's all brought to you by the hackers that you seem to
>> hate so much.
> I don't hate the hack[er]s. I also don't hate the eggheads.
>
> A new feature is outside of the purview of an existing standard (and if it
> existed in the standard first, then it is simply newly implemented).
>
> Standards are only useless because non-eggheads make them so.

Alternatively, standards are only useful if they are useful to non-eggheads.


> A user should be able to request (possibly dynamically) as many
> standards-compliant interfaces as possible from Linux (even if that
> precludes new features or optimizations).

Err, no, and I'll tell you why.

Back in the old days of Unix (circa 1985) there were two "standards",
System V and BSD. Each had a well defined collection of interfaces for
dealing with signals. Both implementation were complete and functional,
but they were different. Unix system vendors, being highly responsive
to customer requirements to run programs written for either variant,
created Unix systems that provided both sets of interfaces at the same
time. Everyone should have been happy, but this was not the case. It
seems that many programmers found the signal processing set-up functions
from BSD preferable to those from System V but the signal handling
interfaces from System V more to their liking than those of BSD, so
they mixed the two and got non-deterministic results. The users got the
interfaces they demanded and a system that did not meet their needs as
a direct result. Eventually a deterministic behavior for mixed metaphor
programs was introduced, effectively creating a third "standard".

Users are a really terrible source of interface specifications. "Hackers"
are often not much better, but at least if the interface is lousy the
developer has the potential to be accountable for it and its improvement.

> Sincerely,
> Michael Witten
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>

