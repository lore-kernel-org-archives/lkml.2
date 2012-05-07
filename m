Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab2EGNtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 09:49:25 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:44868 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162Ab2EGNtY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 09:49:24 -0400
Date: Mon, 7 May 2012 09:43:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] patches for v3.5-rc6.
Message-ID: <20120507134321.GA361@phenom.dumpdata.com>
References: <1336140267-7399-1-git-send-email-konrad.wilk@oracle.com>
 <20120506090446.GU2058@reaktio.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120506090446.GU2058@reaktio.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2012 at 12:04:46PM +0300, Pasi Kärkkäinen wrote:
> On Fri, May 04, 2012 at 10:04:23AM -0400, Konrad Rzeszutek Wilk wrote:
> > Was thinking to push these patches to Linus for v3.5-rc6.
> > 
> 
> Hmm.. that probably should say for v3.4-rc6 ? :)

Yeah :-)
> 
> --  Pasi
> 
> >  arch/x86/xen/enlighten.c    |   40 ++++++++++++++++++++++++++++++++++++++--
> >  arch/x86/xen/mmu.c          |    7 ++++++-
> >  drivers/video/xen-fbfront.c |   25 +++++++++++++++----------
> >  3 files changed, 59 insertions(+), 13 deletions(-)
> > 
> > David Vrabel (1):
> >       xen/pci: don't use PCI BIOS service for configuration space accesses
> > 
> > Julia Lawall (1):
> >       drivers/video/xen-fbfront.c: add missing cleanup code
> > 
> > Konrad Rzeszutek Wilk (2):
> >       xen/apic: Return the APIC ID (and version) for CPU 0.
> >       xen/pte: Fix crashes when trying to see non-existent PGD/PMD/PUD/PTEs
> > 
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
