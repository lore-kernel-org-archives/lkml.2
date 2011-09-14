Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab1INJrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 05:47:07 -0400
Received: from lucidpixels.com ([72.73.18.11]:58206 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755747Ab1INJrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 05:47:05 -0400
Date: Wed, 14 Sep 2011 05:47:04 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Lin Ming <mlin@ss.pku.edu.cn>
cc: linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>,
        "Li, Shaohua" <shaohua.li@intel.com>, Andrew Morton <akpm@google.com>
Subject: Re: 3.0.1: pagevec_lookup+0x1d/0x30, SLAB issues?
In-Reply-To: <CAF1ivSZQ=KKC0gAk93eMVwLSCbeEWr=k6YszuE=sb1+Ue521vw@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1109140543590.29782@p34.internal.lan>
References: <alpine.DEB.2.02.1109111815520.19558@p34.internal.lan> <alpine.DEB.2.02.1109111837200.19558@p34.internal.lan> <CAF1ivSZQ=KKC0gAk93eMVwLSCbeEWr=k6YszuE=sb1+Ue521vw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Sep 2011, Lin Ming wrote:

> On Mon, Sep 12, 2011 at 6:44 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> Hi, Justin
>
> There is a similar bug report at:
> http://marc.info/?t=131594190600005&r=1&w=2
>
> The attached patch from Shaohua fixed the bug.
>
> Could you have a try it?
>

Hi Lin/LKML,

Can you please provide text patch files for what you want me to apply?
I did read that e-mail thread and that could be the culprit, I will patch
and apply as soon as someone points to to the patch locations :)

Justin.

