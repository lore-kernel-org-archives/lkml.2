Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab0LARhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:37:24 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:60568 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab0LARhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:37:24 -0500
Date: Wed, 1 Dec 2010 19:37:20 +0200
From: Alexander Shishkin <virtuoso@slind.org>
To: Julien Cristau <jcristau@debian.org>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alexander Shishkin <virtuoso@slind.org>
Subject: Re: [PATCH 1/4] drm: fix headers to include linux/types.h
Message-ID: <20101201173720.GL26184@shisha.kicks-ass.net>
References: <1291216245-18574-1-git-send-email-virtuoso@slind.org>
 <1291216245-18574-2-git-send-email-virtuoso@slind.org>
 <20101201165418.GU5063@radis.liafa.jussieu.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101201165418.GU5063@radis.liafa.jussieu.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 05:54:18PM +0100, Julien Cristau wrote:
> On Wed, Dec  1, 2010 at 17:10:42 +0200, Alexander Shishkin wrote:
> 
> > For headers that get exported to userland and make use of u32 style
> > type names, it is advised to include linux/types.h.
> > 
> > This fixes 5 headers_check warnings.
> > 
> How many times does this need to be NAKed?  These headers are shared
> with the BSDs, and they include drm.h which has the linux/types.h
> include on linux already.

One of the rules of including files that comes to mind is that one should
never rely on stuff being included from other headers but always explicitly
include those which are needed.
But if compatibility with other OS kernels is a valid reason to disregard
common coding practices, maybe at least it deserves a comment in those files?

But I really couldn't care less about these headers, so this is totally up
to you.

Regards,
--
Alex
