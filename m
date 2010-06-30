Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab0F3S7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 14:59:14 -0400
Received: from relais.videotron.ca ([24.201.245.36]:54980 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757124Ab0F3S7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 14:59:12 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_fSTFMPupBfpCklOGM/nQiw)"
Date: Wed, 30 Jun 2010 14:59:05 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, Christoph Egger <siccegge@cs.fau.de>,
       vamos@i4.informatik.uni-erlangen.de,
       Russell King <linux@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/33] Removing dead SA1101
In-reply-to: <201006302020.52270.marek.vasut@gmail.com>
Message-id: <alpine.LFD.2.00.1006301453450.24097@xanadu.home>
References: <cover.1277911345.git.siccegge@cs.fau.de>
 <7488ec29cdb90212e965f6cd1173141c576c0955.1277911346.git.siccegge@cs.fau.de>
 <alpine.LFD.2.00.1006301255260.24097@xanadu.home>
 <201006302020.52270.marek.vasut@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_fSTFMPupBfpCklOGM/nQiw)
Content-type: TEXT/PLAIN; charset=utf-8
Content-transfer-encoding: 8BIT

On Wed, 30 Jun 2010, Marek Vasut wrote:

> Dne St 30. června 2010 18:57:43 Nicolas Pitre napsal(a):
> > On Wed, 30 Jun 2010, Christoph Egger wrote:
> > > SA1101 doesn't exist in Kconfig, therefore removing all
> > > references for it from the source code.
> > > 
> > > Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> > 
> > Acked-by: Nicolas Pitre <nico@fluxnic.net>
> 
> You're dropping support for a whole CPU here ... is the code redundant or 
> something ?

The SA1101 is not a CPU.  It is a companion chipset for the SA1100.  And 
so far we have no target using it in the tree, and that isn't likely to 
change more than 10 years after the chip availability.  Needless to say 
that the SA1101 has long been unavailable either.

We also have support for the SA1111 which is a similar companion chipset 
for the SA1110.  This is not going away as at least the Neponset 
expansion board for the Assabet development board is using a SA1111.


Nicolas

--Boundary_(ID_fSTFMPupBfpCklOGM/nQiw)--
