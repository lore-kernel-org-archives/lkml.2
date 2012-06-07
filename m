Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab2FGUX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 16:23:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49576 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab2FGUXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 16:23:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAHVUoiQpLpFVmeHCxpXKBvg9y41KcpKOO-_FKA9UTEHSjbhz9g@mail.gmail.com>
References: <CAHVUoiQywo=iHKsXQbsVE7coc1FL9A9qy_a71SK94MKNV0GrKA@mail.gmail.com>
	<CAHVUoiTZmzT3vquaDC65AJfCFZX-qS5GjgjP2-+=0R7skurW5g@mail.gmail.com>
	<CAHVUoiQgcAMr874d_yPfm9ssUBOoX+dNLy9JNCOCYwOCrAKXFQ@mail.gmail.com>
	<CAH3drwacayQEZHOidbKKuJ3KjgMvnYzT0S0csXV2QwSmC8nMxg@mail.gmail.com>
	<CAHVUoiSP7SiWCtYPvKS_1RuAV0upWmT06iN7PR1OE6NAtToirQ@mail.gmail.com>
	<CAH3drwY61Pqd1MXxgSYcHRPJF5pNr2FO7vrM_ULsRvMbYjAhOQ@mail.gmail.com>
	<CAHVUoiQpLpFVmeHCxpXKBvg9y41KcpKOO-_FKA9UTEHSjbhz9g@mail.gmail.com>
Date: Thu, 7 Jun 2012 16:23:54 -0400
Message-ID: <CAH3drwbEoT6RxYHRuY=x9T=Zz2L=UW-p2a0PHanSQV8Wzk9XXw@mail.gmail.com>
Subject: Re: [Regression] [Radeon] Stream command failures and render problems
 in Evergreen (Radeon HD 5600) in kernel 3.4
From: Jerome Glisse <j.glisse@gmail.com>
To: Brian Gitonga Marete <marete@toshnix.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 4:22 PM, Brian Gitonga Marete <marete@toshnix.com> wrote:
> On Thu, Jun 7, 2012 at 11:20 PM, Jerome Glisse <j.glisse@gmail.com> wrote:
>> What happen if you upgrade to xf86-video-ati from git ?
>>
>
> Had actually just though of that and cloned it :) Will try and report.
>
> Thanks!
>
> --
> Brian Gitonga Marete
> Toshnix Systems - http://toshnix.com

If it works please also give me mesa version, and am i right assuming
you are using unity ? Is this a stock ubuntu 12 installation (ie not
custome package) ?

Cheers,
Jerome
