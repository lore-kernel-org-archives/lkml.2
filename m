Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab2LTBAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 20:00:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44997 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab2LTBAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 20:00:39 -0500
Date: Wed, 19 Dec 2012 17:00:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2] Add the values related to buddy system for filtering
 free pages.
Message-Id: <20121219170038.f7b260c3.akpm@linux-foundation.org>
In-Reply-To: <878v8ty200.fsf@xmission.com>
References: <20121210103913.020858db777e2f48c59713b6@mxc.nes.nec.co.jp>
	<20121219161856.e6aa984f.akpm@linux-foundation.org>
	<878v8ty200.fsf@xmission.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2012 16:57:03 -0800
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > Is there any way in which we can move some of this logic into the
> > kernel?  In this case, add some kernel code which uses PageBuddy() on
> > behalf of makedumpfile, rather than replicating the PageBuddy() logic
> > in userspace?
> 
> All that exists when makedumpfile runs is a core file.  So it would have
> to be something like a share library that builds with the kernel and
> then makedumpfile loads.

Can we omit free pages from that core file?

And/or add a section to that core file which flags free pages?
