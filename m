Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab2BVQGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:06:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597Ab2BVQGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:06:12 -0500
Date: Wed, 22 Feb 2012 14:04:30 -0200
From: Rafael Aquini <aquini@redhat.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-mm@kvack.org, Randy Dunlap <rdunlap@xenotime.net>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, Rik van Riel <riel@redhat.com>,
        Josef Bacik <josef@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom: add sysctl to enable slab memory dump
Message-ID: <20120222160429.GA1986@x61.redhat.com>
References: <20120222115320.GA3107@x61.redhat.com>
 <CAOJsxLGz4=2tFQdnnFmGLeFVVPq8pX5=0var7V-9+ddi=TPNVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLGz4=2tFQdnnFmGLeFVVPq8pX5=0var7V-9+ddi=TPNVA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 03:17:23PM +0200, Pekka Enberg wrote:
> On Wed, Feb 22, 2012 at 1:53 PM, Rafael Aquini <aquini@redhat.com> wrote:
> > This, alongside with all other data dumped in OOM events, is very helpful
> > information in diagnosing why there was an OOM condition specially when
> > kernel code is under investigation.
> >
> > Signed-off-by: Rafael Aquini <aquini@redhat.com>
> 
> Makes sense. Do you have an example how an out-of-memory slab cache
> dump looks like?
> 
Yes I do have a couple of dumps taken from some dabbler testing I was
performing. Would it be interesting to introduce a sample at the commit message, or
among the Documentation paragraphs?


> Minor style nit: just define the zeroed variables in this block.
> 
I will adjust those.

Thanks for your feedback!
-- 
Rafael Aquini <aquini@redhat.com>
Software Maintenance Engineer
Red Hat, Inc.
+55 51 4063.9436 / 8426138 (ext)
