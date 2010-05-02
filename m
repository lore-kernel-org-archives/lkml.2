Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab0EBEco (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 00:32:44 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:48184 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab0EBEcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 00:32:43 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: Greg KH <greg@kroah.com>
Subject: Re: [RFC] Yet another (third) dt3155 driver PCI/video4linux compliant
Date: Sun, 2 May 2010 07:29:24 +0300
User-Agent: KMail/1.11.4 (Linux/2.6.34-rc6; KDE/4.2.4; x86_64; ; )
Cc: Scott Smedley <ss@aao.gov.au>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>
References: <201003201118.36736.mitov@issp.bas.bg> <201004301836.09200.mitov@issp.bas.bg> <20100501175853.GB22217@kroah.com>
In-Reply-To: <20100501175853.GB22217@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005020729.24346.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 May 2010 08:58:53 pm Greg KH wrote:
> On Fri, Apr 30, 2010 at 06:36:09PM +0300, Marin Mitov wrote:
> > > I like it, want me to apply it?  
> > 
> > Thank you for liking it. Since the time I sent the patch much in the driver has changed.
> > Now it works (tested only with xawtv -f) with read(), as well as mmap(), but see below
> > for the problems.
> > 
> > Now I send you an updated patch, but it is not reviewed. You could either review it :-) or
> > apply the previous patch. In the last case I will prepare a difference patch and will send it.
> 
> This one worked for me, with the exception that you forgot to modify the
> drivers/staging/Makefile file to add the driver to the build.  I've
> fixed that up, and it builds on my i386 box, so I've added it to my
> tree.

Yes, this is my fault, sorry, and thank you.

Marin Mitov

> 
> thanks,
> 
> greg k-h
> 
