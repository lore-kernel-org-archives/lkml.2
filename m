Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab2FJO2Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 10:28:16 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44554 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab2FJO2P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 10:28:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAHVUoiRt0PBxNvgRazSPCE1=gGtDBTdQ4kmXhUvkfeJAMWcq3w@mail.gmail.com>
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
	<CAHVUoiRt0PBxNvgRazSPCE1=gGtDBTdQ4kmXhUvkfeJAMWcq3w@mail.gmail.com>
Date: Sun, 10 Jun 2012 15:28:14 +0100
Message-ID: <CAPM=9tx5-A_SumZ+8Y0xk9NT1p0v-wmqnbgKN+nmSV-J1NCFcg@mail.gmail.com>
Subject: Re: [Regression] [Radeon] Stream command failures and render problems
 in Evergreen (Radeon HD 5600) in kernel 3.4
From: Dave Airlie <airlied@gmail.com>
To: Brian Gitonga Marete <marete@toshnix.com>
Cc: Jerome Glisse <j.glisse@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2012 at 12:24 PM, Brian Gitonga Marete
<marete@toshnix.com> wrote:
> On Sat, Jun 9, 2012 at 7:33 PM, Brian Gitonga Marete <marete@toshnix.com> wrote:
>> On Sat, Jun 9, 2012 at 7:29 PM, Dave Airlie <airlied@gmail.com> wrote:
>>>>
>>>> OK. I actually hadn't gotten around to testing yet. Will do so later
>>>> today. About libdrm, should I test against git or the Ubuntu version?
>>>
>>> The Ubuntu version please.
>>
>> OK.Will report results in a couple of hours :)
>
> Hello. Got around to this after some delay and after applying v3 of
> them patch to 3.4, where it applied cleanly, I get this during build:
>
> drivers/gpu/drm/radeon/evergreen_cs.c: In function
> ‘evergreen_cs_track_validate_cb’:
> drivers/gpu/drm/radeon/evergreen_cs.c:447:28: error: request for
> member ‘ptr’ in something not a structure or union

Can you change the -> to a . on that line

Dave.
