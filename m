Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab2FJS3Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 14:29:16 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55915 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab2FJS3O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 14:29:14 -0400
MIME-Version: 1.0
X-Originating-IP: [41.212.116.88]
In-Reply-To: <CAPM=9tx5-A_SumZ+8Y0xk9NT1p0v-wmqnbgKN+nmSV-J1NCFcg@mail.gmail.com>
References: <CAHVUoiQywo=iHKsXQbsVE7coc1FL9A9qy_a71SK94MKNV0GrKA@mail.gmail.com>
 <CAHVUoiTZmzT3vquaDC65AJfCFZX-qS5GjgjP2-+=0R7skurW5g@mail.gmail.com>
 <CAHVUoiQgcAMr874d_yPfm9ssUBOoX+dNLy9JNCOCYwOCrAKXFQ@mail.gmail.com>
 <CAH3drwacayQEZHOidbKKuJ3KjgMvnYzT0S0csXV2QwSmC8nMxg@mail.gmail.com>
 <CAHVUoiSP7SiWCtYPvKS_1RuAV0upWmT06iN7PR1OE6NAtToirQ@mail.gmail.com>
 <CAH3drwY61Pqd1MXxgSYcHRPJF5pNr2FO7vrM_ULsRvMbYjAhOQ@mail.gmail.com>
 <CAHVUoiTfooPSXyVpcg_Khc0rzYcnmvAbGgfko42hOxqukc91_A@mail.gmail.com>
 <CAHVUoiT4FgEpWDLtzfTUaCTZR-rFx76E3MRdU8u9swjmt74ZQg@mail.gmail.com>
 <CAHVUoiQ_csZeh_FEHaCkqmJvHO+Q=UF2Va7V19G-3C=xuSYTPw@mail.gmail.com>
 <CAH3drwa430bUfY4ZHfn583JsDU5Sv=Y5WNaWWXm=a1XpJV1iSw@mail.gmail.com>
 <CAHVUoiSc3mzrgXFo5-T=8HiYYUBTMhBz0TqUwZSek=VgfhEoyA@mail.gmail.com>
 <CAH3drwaBpnicWa=pLnKgxsOb4t4pe_kHsYZW4Ei3q-wKYCA=Rw@mail.gmail.com>
 <CAHVUoiS-rCKnpodhq+8ptg3cVzm2wvtiGf7y4pamnGmz82BDEw@mail.gmail.com>
 <CAPM=9tzWypx7Q49YZW4C9oHre47GEAfh=bhsCSREr2U=rAwobA@mail.gmail.com>
 <CAHVUoiQWX-shQHYahxh3pqcyKyeiLLj6X9bG_0DVShBr8qDwUQ@mail.gmail.com>
 <CAHVUoiRt0PBxNvgRazSPCE1=gGtDBTdQ4kmXhUvkfeJAMWcq3w@mail.gmail.com> <CAPM=9tx5-A_SumZ+8Y0xk9NT1p0v-wmqnbgKN+nmSV-J1NCFcg@mail.gmail.com>
From: Brian Gitonga Marete <marete@toshnix.com>
Date: Sun, 10 Jun 2012 21:28:53 +0300
Message-ID: <CAHVUoiSp+o58z_-FX73VXcUPzQg1CHW0=B14PYNb-MHDrWm1Vw@mail.gmail.com>
Subject: Re: [Regression] [Radeon] Stream command failures and render problems
 in Evergreen (Radeon HD 5600) in kernel 3.4
To: Dave Airlie <airlied@gmail.com>
Cc: Jerome Glisse <j.glisse@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2012 at 5:28 PM, Dave Airlie <airlied@gmail.com> wrote:
> On Sun, Jun 10, 2012 at 12:24 PM, Brian Gitonga Marete
> <marete@toshnix.com> wrote:
>> On Sat, Jun 9, 2012 at 7:33 PM, Brian Gitonga Marete <marete@toshnix.com> wrote:
>>> On Sat, Jun 9, 2012 at 7:29 PM, Dave Airlie <airlied@gmail.com> wrote:
>>>>>
>>>>> OK. I actually hadn't gotten around to testing yet. Will do so later
>>>>> today. About libdrm, should I test against git or the Ubuntu version?
>>>>
>>>> The Ubuntu version please.
>>>
>>> OK.Will report results in a couple of hours :)
>>
>> Hello. Got around to this after some delay and after applying v3 of
>> them patch to 3.4, where it applied cleanly, I get this during build:
>>
>> drivers/gpu/drm/radeon/evergreen_cs.c: In function
>> ‘evergreen_cs_track_validate_cb’:
>> drivers/gpu/drm/radeon/evergreen_cs.c:447:28: error: request for
>> member ‘ptr’ in something not a structure or union
>
> Can you change the -> to a . on that line

Actually, the other way around :) Compilation has now passed that
point and will report on test results.


-- 
Brian Gitonga Marete
Toshnix Systems - http://toshnix.com
