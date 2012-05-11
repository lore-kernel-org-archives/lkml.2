Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195Ab2EKSaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:30:21 -0400
Received: from fieldses.org ([174.143.236.118]:44620 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932622Ab2EKSaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:30:18 -0400
Date: Fri, 11 May 2012 14:30:17 -0400
To: John Heim <jheim@math.wisc.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: patch for speakup serial hardware synths
Message-ID: <20120511183016.GA15149@fieldses.org>
References: <E0BBA37A8B0840BF82FE8AEADEBE8B5D@math.wisc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E0BBA37A8B0840BF82FE8AEADEBE8B5D@math.wisc.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 10:36:54AM -0500, John Heim wrote:
> A few weeks ago I asked about a problem with the speakup screen
> reader code. It does not work with serial hardware speech
> synthesizers. But I managed to get it working. How can I submit my
> fix for integration into the kernel code. The patch file can be
> downloaded here:
> http://www.math.wisc.edu/~jheim/downloads/patch-2012-03-06.patch

See Documentation/SubmittingPatches.

As a first approximation:
	- try to figure out who maintains that code (by looking in
	  MAINTAINERS and/or looking at "git log
	  path/to/file/you/modified" to see who touched it lately, and
	  make sure they're cc'd on your mail.
	- generate the diff with "diff -up".
	- append the patch to your email so we can reply and quote it if
	  necessary.
	- give a few more details about what was broken before and how
	  this fixed it.

--b.

> 
> To install it you cd to the linux source directory and do this:
> patch -i patch-2012-03-06.patch drivers/staging/speakup/serialio.c"
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
