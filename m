Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab0F3SXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 14:23:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58901 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab0F3SXL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 14:23:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=vUrZA+Vc4eoG4y8nMo1+RTRnC5cg6yDADd9sVVwtUabh6Ufwr9bXyMKINhwbLbhh+7
         ExutkxPa1FPLdPNwlLGO+J3amH3S6teidLlLOFCJd4ZBa7q4x6t/5A6fEN/SFvbQKtyl
         IXsMapnODKr60jdWwmNIYedw/mzeioYQaigNs=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 08/33] Removing dead SA1101
Date: Wed, 30 Jun 2010 20:20:52 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.33-2-amd64; KDE/4.4.3; x86_64; ; )
Cc: Nicolas Pitre <nico@fluxnic.net>, Christoph Egger <siccegge@cs.fau.de>,
       vamos@i4.informatik.uni-erlangen.de,
       Russell King <linux@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
References: <cover.1277911345.git.siccegge@cs.fau.de> <7488ec29cdb90212e965f6cd1173141c576c0955.1277911346.git.siccegge@cs.fau.de> <alpine.LFD.2.00.1006301255260.24097@xanadu.home>
In-Reply-To: <alpine.LFD.2.00.1006301255260.24097@xanadu.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006302020.52270.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne St 30. června 2010 18:57:43 Nicolas Pitre napsal(a):
> On Wed, 30 Jun 2010, Christoph Egger wrote:
> > SA1101 doesn't exist in Kconfig, therefore removing all
> > references for it from the source code.
> > 
> > Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> 
> Acked-by: Nicolas Pitre <nico@fluxnic.net>

You're dropping support for a whole CPU here ... is the code redundant or 
something ?
> 
> > ---
> > 
> >  arch/arm/mach-sa1100/include/mach/SA-1101.h  |  925
> >  -------------------------- arch/arm/mach-sa1100/include/mach/hardware.h
> >  |    4 -
> >  2 files changed, 0 insertions(+), 929 deletions(-)
> >  delete mode 100644 arch/arm/mach-sa1100/include/mach/SA-1101.h
> 
> [...]
> 
> 
> Nicolas
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
