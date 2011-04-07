Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab1DGOYC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 10:24:02 -0400
Received: from smtp-out.google.com ([74.125.121.67]:18302 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab1DGOYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 10:24:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=d+f/SvYMIuQAbXq1IXCgOiCRlp9ZbfGklL8fNcoT0nwUbmym4ixZ+Eu/qqIv1ZP+mf
         yHKz0hZ20Bih+nrCYW2g==
Date: Thu, 7 Apr 2011 07:24:02 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Robert Swiecki <robert@swiecki.net>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Michel Lespinasse <walken@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] mm: fix possible cause of a page_mapped BUG
In-Reply-To: <BANLkTim-hyXpLj537asC__8exMo3o-WCLA@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1104070718120.28555@sister.anvils>
References: <alpine.LSU.2.00.1102232136020.2239@sister.anvils> <AANLkTi==MQV=_qq1HaCxGLRu8DdT6FYddqzBkzp1TQs7@mail.gmail.com> <AANLkTimv66fV1+JDqSAxRwddvy_kggCuhoJLMTpMTtJM@mail.gmail.com> <alpine.LSU.2.00.1103182158200.18771@sister.anvils>
 <BANLkTinoNMudwkcOOgU5d+imPUfZhDbWWQ@mail.gmail.com> <AANLkTimfArmB7judMW7Qd4ATtVaR=yTf_-0DBRAfCJ7w@mail.gmail.com> <BANLkTi=Limr3NUaG7RLoQLv5TuEDmm7Rqg@mail.gmail.com> <BANLkTi=UZcocVk_16MbbV432g9a3nDFauA@mail.gmail.com> <BANLkTi=KTdLRC_hRvxfpFoMSbz=vOjpObw@mail.gmail.com>
 <BANLkTindeX9-ECPjgd_V62ZbXCd7iEG9_w@mail.gmail.com> <BANLkTikcZK+AQvwe2ED=b0dLZ0hqg0B95w@mail.gmail.com> <BANLkTimV1f1YDTWZUU9uvAtCO_fp6EKH9Q@mail.gmail.com> <BANLkTi=tavhpytcSV+nKaXJzw19Bo3W9XQ@mail.gmail.com> <alpine.LSU.2.00.1104060837590.4909@sister.anvils>
 <BANLkTi=-Zb+vrQuY6J+dAMsmz+cQDD-KUw@mail.gmail.com> <BANLkTim0MZfa8vFgHB3W6NsoPHp2jfirrA@mail.gmail.com> <BANLkTim-hyXpLj537asC__8exMo3o-WCLA@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Apr 2011, Robert Swiecki wrote:
> >
> > Testing with Linus' patch. Will let you know in a few hours.
> 
> Ok, nothing happened after ~20h. The bug, usually, was triggered within 5-10h.
> 
> I can add some printk in this condition, and let it run for a few days
> (I will not have access to my testing machine throughout that time),
> if you think this will confirm your hypothesis.

That's great, thanks Robert.  If the machine has nothing better to do,
then it would be nice to let it run a little longer (a few days if that's
what suits you), but it does look good so far.  Though I'm afraid you'll
now discover something else entirely ;)

Hugh
