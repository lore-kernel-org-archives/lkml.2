Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab0DKS2q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 14:28:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:53088 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456Ab0DKS2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 14:28:44 -0400
Date: Sun, 11 Apr 2010 20:28:35 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       rvinyard@cs.nmsu.edu
Subject: Re: [PATCH mmotm] hid-picolcd: depends on LCD_CLASS_DEVICE
In-Reply-To: <20100411121745.6a500755@neptune.home>
Message-ID: <alpine.LNX.2.00.1004112028080.8345@pobox.suse.cz>
References: <201004052336.o35NaeSE015814@imap1.linux-foundation.org> <20100405220414.9d90da83.randy.dunlap@oracle.com> <alpine.LNX.2.00.1004061038510.8345@pobox.suse.cz> <20100406105635.5384a087@pluto.restena.lu> <20100406082614.79aaf1c5.randy.dunlap@oracle.com>
 <20100406183535.7de3c628@neptune.home> <20100406095633.49ec957a.randy.dunlap@oracle.com> <20100406230434.1336c317@neptune.home> <20100407092010.4cd60ece.randy.dunlap@oracle.com> <20100407203132.7fe2d0f1@neptune.home> <alpine.LNX.2.00.1004081441460.8345@pobox.suse.cz>
 <20100411121745.6a500755@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Apr 2010, Bruno Prémont wrote:

> > > +config HID_PICOLCD_FB
> > > +	bool "Framebuffer support"
> > > +	default !EMBEDDED
> > > +	depends on HID_PICOLCD
> > > +	depends on HID_PICOLCD=FB || FB=y
> > > +	select FB_DEFERRED_IO
> > > +	select FB_SYS_FILLRECT
> > > +	select FB_SYS_COPYAREA
> > > +	select FB_SYS_IMAGEBLIT
> > > +	select FB_SYS_FOPS
> > 
> > Could we perhaps also make the sub-choices for individual features 
> > availabel only if !EMBEDDED as well?
> 
> Here is an updated patch to make the sub-choices visible only in
> EMBEDDED case.

Applied, thanks Bruno.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
