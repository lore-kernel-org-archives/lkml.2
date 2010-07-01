Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab0GAAD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 20:03:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51200 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab0GAADY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 20:03:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=Yyqxp1gF1jf8SssKsQENzdZai73+3BFOZ+v0L9R13ItVwhrgoV205JvRJHv+sJ9RRV
         0VFwBAKXYibmmNSMxBjcAo2irhppo5NN4uw9n2o07Fg7TpBJMhJumqc5FdNivCDMmtCi
         fJMdu1K3C7A8Y/FVrmid40b7TjhvNhPvM8tm0=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH 08/33] Removing dead SA1101
Date: Thu, 1 Jul 2010 02:01:05 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.33-2-amd64; KDE/4.4.3; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Christoph Egger <siccegge@cs.fau.de>,
       vamos@i4.informatik.uni-erlangen.de,
       Russell King <linux@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
References: <cover.1277911345.git.siccegge@cs.fau.de> <201006302020.52270.marek.vasut@gmail.com> <alpine.LFD.2.00.1006301453450.24097@xanadu.home>
In-Reply-To: <alpine.LFD.2.00.1006301453450.24097@xanadu.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201007010201.05424.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne St 30. června 2010 20:59:05 Nicolas Pitre napsal(a):
> On Wed, 30 Jun 2010, Marek Vasut wrote:
> > Dne St 30. června 2010 18:57:43 Nicolas Pitre napsal(a):
> > > On Wed, 30 Jun 2010, Christoph Egger wrote:
> > > > SA1101 doesn't exist in Kconfig, therefore removing all
> > > > references for it from the source code.
> > > > 
> > > > Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> > > 
> > > Acked-by: Nicolas Pitre <nico@fluxnic.net>
> > 
> > You're dropping support for a whole CPU here ... is the code redundant or
> > something ?
> 
> The SA1101 is not a CPU.  It is a companion chipset for the SA1100.  And
> so far we have no target using it in the tree, and that isn't likely to
> change more than 10 years after the chip availability.  Needless to say
> that the SA1101 has long been unavailable either.
> 
> We also have support for the SA1111 which is a similar companion chipset
> for the SA1110.  This is not going away as at least the Neponset
> expansion board for the Assabet development board is using a SA1111.
> 
> 
> Nicolas

Oh I see. Thanks for clearing that.
