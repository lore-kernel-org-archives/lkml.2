Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab0LAUMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 15:12:31 -0500
Received: from xenotime.net ([72.52.115.56]:42700 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755647Ab0LAUM3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 15:12:29 -0500
Date: Wed, 1 Dec 2010 12:12:25 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Dave Airlie <airlied@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Julien Cristau <jcristau@debian.org>,
        Alexander Shishkin <virtuoso@slind.org>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 1/4] drm: fix headers to include
 linux/types.h
Message-Id: <20101201121225.7a478a25.rdunlap@xenotime.net>
In-Reply-To: <AANLkTikYmVQ3A+DArFq+7z1MvhZDR6z+3-VdJpoRMV1K@mail.gmail.com>
References: <1291216245-18574-1-git-send-email-virtuoso@slind.org>
	<1291216245-18574-2-git-send-email-virtuoso@slind.org>
	<20101201165418.GU5063@radis.liafa.jussieu.fr>
	<20101201113841.46e92def.akpm@linux-foundation.org>
	<AANLkTikYmVQ3A+DArFq+7z1MvhZDR6z+3-VdJpoRMV1K@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Dec 2010 05:55:59 +1000 Dave Airlie wrote:

> On Thu, Dec 2, 2010 at 5:38 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed, 1 Dec 2010 17:54:18 +0100
> > Julien Cristau <jcristau@debian.org> wrote:
> >
> >> On Wed, Dec  1, 2010 at 17:10:42 +0200, Alexander Shishkin wrote:
> >>
> >> > For headers that get exported to userland and make use of u32 style
> >> > type names, it is advised to include linux/types.h.
> >> >
> >> > This fixes 5 headers_check warnings.
> >> >
> >> How many times does this need to be NAKed?
> >
> > Until someone gets a clue and puts comments in there explaining this?
> 
> how about someone fixing the dumb scripts to understand that C header
> includes aren't single level.

Still, drm is an exception here, so it needs to be documented as such.


> Like 10 people have posted this patch and not one has come back with a
> fix for the app after I pointed it out, like really if people think
> they can write C good enough to send kernel patches,
> maybe they could put some more effort in and actually fix a real problem.
> 
> We should start hashing signed-off-by's so people can't get any glory from them.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
