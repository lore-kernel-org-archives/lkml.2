Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab0H2NiA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 09:38:00 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:36847 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab0H2Nh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 09:37:59 -0400
Date: Sun, 29 Aug 2010 14:37:53 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Ivan Bulatovic <combuster@gmx.com>,
        Chris Wilson <chris@chris-wilson.co.uk>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, jbarnes@virtuousgeek.org,
        eric@anholt.net, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: i915: 2.6.36-rc2 wrong resolution on gdm start
Message-ID: <20100829133753.GB19049@sucs.org>
References: <1282611655.2177.19.camel@localhost.localdomain> <8u3s8d$jcftu0@orsmga001.jf.intel.com> <1282638912.2191.17.camel@localhost.localdomain> <89kc63$hrqmar@fmsmga002.fm.intel.com> <1282641126.2259.15.camel@localhost.localdomain> <AANLkTikGRnF8jZLmwA8Ey203K1rMbY1jw6Gb_cAMYmyo@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikGRnF8jZLmwA8Ey203K1rMbY1jw6Gb_cAMYmyo@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 29, 2010 at 02:29:32PM +0300, Pekka Enberg wrote:
> 
> I'm still seeing wrong resolution with my i915 Macbook with latest
> Linus' git. Is there a fix in the pipeline or should we start looking
> for a commit to revert? As a slab maintainer, I'm supposed to be able
> to work with -rc kernels and this particular bug is pretty damn
> annoying.

I've been seeing a variety of strange behaviour since
9d0498a2bf7455159b317f19531a3e5db2ecc9c4 too (I found I could narrow it
down in http://lkml.org/lkml/2010/8/24/280 but the change mentioned
there doesn't seem to help others). I've filed
https://bugs.freedesktop.org/show_bug.cgi?id=29857 which summarises the
different strange behaviour that I've seen generated and the steps I've
used to reproduce them. Unfortunately this week I'm not going to have
much time for the tests I was able to do last week.

-- 
Sitsofe | http://sucs.org/~sits/
