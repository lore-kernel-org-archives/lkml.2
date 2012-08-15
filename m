Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab2HOUU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:20:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34297 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756691Ab2HOUUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 16:20:52 -0400
Date: Wed, 15 Aug 2012 13:20:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        kosaki.motohiro@gmail.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, davej@redhat.com, mgorman@suse.de, cl@linux.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 0/6][resend] mempolicy memory corruption fixlet
Message-Id: <20120815132050.12f4dec4.akpm@linux-foundation.org>
In-Reply-To: <CA+5PVA7YejzbWDEpX=gj8s2QAQtgoxyNUUa5HhGtVGY+2BHqRA@mail.gmail.com>
References: <1339406250-10169-1-git-send-email-kosaki.motohiro@gmail.com>
	<CA+5PVA4CE0kwD1FmV=081wfCObVYe5GFYBQFO9_kVL4JWJBqpA@mail.gmail.com>
	<50201BB5.9050005@jp.fujitsu.com>
	<CA+5PVA7YejzbWDEpX=gj8s2QAQtgoxyNUUa5HhGtVGY+2BHqRA@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2012 07:40:46 -0400
Josh Boyer <jwboyer@gmail.com> wrote:

> >> I don't see these patches queued anywhere.  They aren't in linux-next,
> >> mmotm, or Linus' tree.  Did these get dropped?  Is the revert still
> >> needed?
> >
> > Sorry. my fault. yes, it is needed. currently, Some LTP was fail since
> > Mel's "mm: mempolicy: Let vma_merge and vma_split handle vma->vm_policy linkages" patch.
> 
> The series still isn't queued anywhere.  Are you planning on resending
> it again, or should it get picked up in a particular tree?

The patches need a refresh and a retest please, including incorporation
of Christoph's changelog modifications.

And for gawd's sake, please stop using my google address!  It messes me
all up.
