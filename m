Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab0EBENR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 00:13:17 -0400
Received: from kroah.org ([198.145.64.141]:37603 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627Ab0EBENE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 00:13:04 -0400
Date: Sat, 1 May 2010 10:58:53 -0700
From: Greg KH <greg@kroah.com>
To: Marin Mitov <mitov@issp.bas.bg>
Cc: Scott Smedley <ss@aao.gov.au>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFC] Yet another (third) dt3155 driver PCI/video4linux
	compliant
Message-ID: <20100501175853.GB22217@kroah.com>
References: <201003201118.36736.mitov@issp.bas.bg> <201003202140.16412.mitov@issp.bas.bg> <20100427231839.GA26416@kroah.com> <201004301836.09200.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004301836.09200.mitov@issp.bas.bg>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 06:36:09PM +0300, Marin Mitov wrote:
> > I like it, want me to apply it?  
> 
> Thank you for liking it. Since the time I sent the patch much in the driver has changed.
> Now it works (tested only with xawtv -f) with read(), as well as mmap(), but see below
> for the problems.
> 
> Now I send you an updated patch, but it is not reviewed. You could either review it :-) or
> apply the previous patch. In the last case I will prepare a difference patch and will send it.

This one worked for me, with the exception that you forgot to modify the
drivers/staging/Makefile file to add the driver to the build.  I've
fixed that up, and it builds on my i386 box, so I've added it to my
tree.

thanks,

greg k-h
