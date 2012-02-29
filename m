Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab2B2XcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:32:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39068 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757221Ab2B2XcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:32:18 -0500
Date: Wed, 29 Feb 2012 15:32:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: extend prefault helpers to fault in more than
 PAGE_SIZE
Message-Id: <20120229153216.8c3ae31d.akpm@linux-foundation.org>
In-Reply-To: <20120229231453.GA6662@phenom.ffwll.local>
References: <20120224124003.93780408.akpm@linux-foundation.org>
	<1330524211-2698-1-git-send-email-daniel.vetter@ffwll.ch>
	<20120229150146.2cc64fac.akpm@linux-foundation.org>
	<20120229231453.GA6662@phenom.ffwll.local>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2012 00:14:53 +0100
Daniel Vetter <daniel@ffwll.ch> wrote:

> I'll redo this patch by adding _multipage versions of these 2 functions
> for i915.

OK, but I hope "for i915" doesn't mean "private to"!  Put 'em in
pagemap.h, for maintenance reasons and because they are generic.

Making them inline is a bit sad, but that's OK for now - they have few
callsites.
