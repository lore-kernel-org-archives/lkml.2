Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab1FHKqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 06:46:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54195 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab1FHKqA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 06:46:00 -0400
Subject: Re: bdi_min_ratio never shrinks, ultimately preventing valid
 setting of min_ratio
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml@pengaru.com, linux-kernel@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>, miklos <miklos@szeredi.hu>
In-Reply-To: <1307525113.2322.291.camel@twins>
References: <20110601002854.GV5753@shells.gnugeneration.com>
	 <1307015011.2497.633.camel@laptop>
	 <20110602183244.GB5753@shells.gnugeneration.com>
	 <1307049958.2497.726.camel@laptop>
	 <20110607171347.a0bbdfd8.akpm@linux-foundation.org>
	 <1307525113.2322.291.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 08 Jun 2011 12:45:48 +0200
Message-ID: <1307529948.2322.322.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-08 at 11:25 +0200, Peter Zijlstra wrote:
> On Tue, 2011-06-07 at 17:13 -0700, Andrew Morton wrote:
> 
> > I grabbed this, wrote a changelog and stuck your signed-off-by on it. 
> 
> Thanks, I was still waiting for feedback :/
> 
> > I also added a cc:stable but I didn't work out how far back in time it
> > goes.  A long way, I think?
> 
> Yeah, ages ago:
> 
> commit 189d3c4a94ef19fca2a71a6a336e9fda900e25e7
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Wed Apr 30 00:54:35 2008 -0700
> 
>     mm: bdi: allow setting a minimum for the bdi dirty limit
> 
> git describe --contains doesn't seem to want to give a -linus release,
> my git foo is too weak :-(

OK after it was pointed out that --match takes a glob, not a regex, it
gives:

# git describe --contains  189d3c4a94ef19fca2a71a6a336e9fda900e25e7 --match 'v*'
v2.6.26-rc1~155

So yeah, _waaaay_ back.
