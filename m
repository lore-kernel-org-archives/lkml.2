Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab0FAA5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 20:57:23 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55017 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab0FAA5W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 20:57:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=mIdVyYJ84SBZ/qsW28LIu1fBP0QkOYeb4zngboqtBiWy/Ycy3dSsUcXJSiI/cygDyl
         g2hHLCi8BbqwYiIWFpHx4UhJtcx0Vh0rMmTOnSOw29QNLUqj0W9FWENAaAkEi+84jVno
         KlMrZuAc4NoFW3VCdOwSs68GIgJbXkKdVG6/o=
MIME-Version: 1.0
In-Reply-To: <2073679454094428814@unknownmsgid>
References: <20100512133815.0d048a86@annuminas.surriel.com> 
	<20100512134029.36c286c4@annuminas.surriel.com> <20100512210216.GP24989@csn.ul.ie> 
	<4BEB18BB.5010803@redhat.com> <20100513095439.GA27949@csn.ul.ie> 
	<20100513103356.25665186@annuminas.surriel.com> <20100513140919.0a037845.akpm@linux-foundation.org> 
	<4BFC9CCF.6000809@redhat.com> <20100525211520.16e3a034.akpm@linux-foundation.org> 
	<2073679454094428814@unknownmsgid>
From: james toy <toyj@union.edu>
Date: Mon, 31 May 2010 20:57:01 -0400
X-Google-Sender-Auth: oS-UXL94QKBpUGMuQBS4FlgAljY
Message-ID: <AANLkTikUTPz3EwOr09rMNDiSRdvlW9Va9Y3_YuQMecLj@mail.gmail.com>
Subject: Re: [PATCH -v2 4/5] always lock the root (oldest) anon_vma
To: james toy <nil@0xabadba.be>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>, Andrea Arcangeli <aarcange@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, Linux-MM <linux-mm@kvack.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, james toy <mail@wfys.org>,
       James Toy <0xbaadface@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is now fixed; I am truly sorry for the delay but it was out of my
hands.  The sysadmin had git 1.7.1 but an old version of guilt (0.3.2)
which was incompatible.  After the upgrade the watchdog program is
working fine.  Again thanks for alerting me to this and i'll be
keeping a closer eye on it since i'm working on the kernel more now
days.

respectfully,

=jt

On Wed, May 26, 2010 at 01:46, james toy <nil@0xabadba.be> wrote:
> I'll get after this asap; sorry.  I'm finishing my last trimester of
> my B.S.  I'll send a message when it's back up with the offending patch.
>
> =jt
>
> On May 26, 2010, at 0:15, Andrew Morton <akpm@linux-foundation.org>
> wrote:
>
>> On Wed, 26 May 2010 00:00:15 -0400 Rik van Riel <riel@redhat.com>
>> wrote:
>>
>>> On 05/13/2010 05:09 PM, Andrew Morton wrote:
>>>
>>>> I'm not very confident in merging all these onto the current MM
>>>> pile.
>>>
>>> Blah.  I thought I just did that (and wondered why it was
>>> so easy), and then I saw that the MMOTM git tree is old
>>> and does not have the COMPACTION code :(
>>>
>>
>> Oh.  James's mmotm->git bot might have broken.
>
