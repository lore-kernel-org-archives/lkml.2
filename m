Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614Ab0FLBsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 21:48:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751115Ab0FLBsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 21:48:10 -0400
Date: Fri, 11 Jun 2010 18:48:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-06-11-16-40 uploaded
Message-Id: <20100611184810.7f8ce71d.akpm@linux-foundation.org>
In-Reply-To: <20100611183152.7537b30b.randy.dunlap@oracle.com>
References: <201006120008.o5C08gC3027843@imap1.linux-foundation.org>
	<20100611183152.7537b30b.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 18:31:52 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Fri, 11 Jun 2010 16:40:13 -0700 akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2010-06-11-16-40 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://zen-kernel.org/kernel/mmotm.git
> > 
> > It contains the following patches against 2.6.35-rc2:
> 
> > mm-extend-ksm-refcounts-to-the-anon_vma-root.patch
> > mm-extend-ksm-refcounts-to-the-anon_vma-root-fix.patch
> 
> latter patch file contains patches to mm/rmap.c.orig,
> which patch FAILs to apply:

Geeze I hate it when people do that.  My "work out what files are added
or removed or altered by a patch" script needs fixing.

