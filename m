Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab1GGTvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:51:19 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:52866 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab1GGTvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:51:17 -0400
Subject: Re: Build issue with linux next. duplicate member _count in
 mm_types.h
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: piotr@hosowicz.com, Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <alpine.DEB.2.00.1107071413290.24437@router.home>
References: <4E143120.2020501@cam.ac.uk>
	 <alpine.DEB.2.00.1107060933460.17202@router.home>
	 <4E15AF1C.7080103@example.com>
	 <alpine.DEB.2.00.1107070841500.17376@router.home>
	 <4E15B945.5060805@example.com> <1310065670.21902.62.camel@jaguar>
	 <alpine.DEB.2.00.1107071413290.24437@router.home>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 07 Jul 2011 22:51:15 +0300
Message-ID: <1310068275.21902.63.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-07 at 14:14 -0500, Christoph Lameter wrote:
> On Thu, 7 Jul 2011, Pekka Enberg wrote:
> 
> > > I attach it. Your patch seems to had worked, I finish making the package.
> >
> > I'm confused. Does Christoph's patch fix the problem for everyone?
> 
> Guess so (heard nothing to the contrary) but I still would like to know
> what caused it. My best guess right now its gccs 4.6s stricter checking.

OK, I applied the patch. Hopefully it will fix build breakage in
linux-next.


