Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab0LBNaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 08:30:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55161 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757419Ab0LBNaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 08:30:07 -0500
Date: Thu, 2 Dec 2010 14:30:03 +0100
From: Michal Marek <mmarek@suse.cz>
To: Thomas Chou <thomas@wytron.com.tw>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw
Subject: Re: [PATCH] gen_init_cpio: remove leading `/' from file names
Message-ID: <20101202133002.GC18216@sepie.suse.cz>
References: <1286349233-31721-1-git-send-email-thomas@wytron.com.tw>
 <AANLkTikN_B-xq=Ge1gx-T5356K5ULd7u11y-mmS=BXMO@mail.gmail.com>
 <4CE49503.90607@wytron.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE49503.90607@wytron.com.tw>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 10:52:51AM +0800, Thomas Chou wrote:
> Hi Andrew and Michal,
> 
> On 10/06/2010 10:51 PM, Mike Frysinger wrote:
> >On Wed, Oct 6, 2010 at 03:13, Thomas Chou wrote:
> >>When we extracted the generated cpio archive using "cpio -id" command,
> >>it complained,
> >>
> >>cpio: Removing leading `/' from member names
> >>var/run
> >>cpio: Removing leading `/' from member names
> >>var/lib
> >>cpio: Removing leading `/' from member names
> >>var/lib/misc
> >>
> >>It is worse with the latest "cpio" or "pax", which tries to overwrite
> >>the host file system with the leading '/'.
> >
> >seems to work as intended on Blackfin systems, and i cant see any
> >reason to require the leading slash, so:
> >Acked-by: Mike Frysinger<vapier@gentoo.org>
> >-mike
> >
> >
> 
> Would you please review this patch? It is not clear as who should
> handle this with the MAINTAINERS.

Applied to kbuild-2.6.git#kbuild, thanks a lot.

Michal
