Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987Ab2FABHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 21:07:09 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:38256 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932956Ab2FABHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 21:07:07 -0400
Date: Fri, 1 Jun 2012 11:06:47 +1000
From: Christopher Yeoh <cyeoh@au1.ibm.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: CROSS_MEMORY_ATTACH default y?
Message-ID: <20120601110647.2c446aa7@rockpopper>
In-Reply-To: <20120531154224.GL14515@aftab.osrc.amd.com>
References: <20120531153512.GK14515@aftab.osrc.amd.com>
	<20120531154224.GL14515@aftab.osrc.amd.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12053114-5490-0000-0000-000001839077
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2012 17:42:24 +0200
Borislav Petkov <bp@amd64.org> wrote:

> + LKML.
> 
> On Thu, May 31, 2012 at 05:35:12PM +0200, Borislav Petkov wrote:
> > Hi,
> > 
> > can you please explain why CROSS_MEMORY_ATTACH is default y? Why
> > should those process_vm_{readv,writev} syscalls be enabled by
> > default?

There was a bit of a discussion at the time I submitted the patch:

https://lkml.org/lkml/2012/4/23/606

Basically CMA had been in for a while already in a released kernel
before I submitted a patch to allow it to be disabled. So the patch
preserves existing behaviour.

Regards,

Chris
-- 
cyeoh@au1.ibm.com

