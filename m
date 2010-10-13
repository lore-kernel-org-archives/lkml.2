Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab0JMO4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 10:56:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52716 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab0JMO4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 10:56:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Casey Dahlin <cdahlin@redhat.com>
Subject: Re: A question about ZONE_DMA
Date: Wed, 13 Oct 2010 16:57:17 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <20101013145240.GE12467@foucault.redhat.com>
In-Reply-To: <20101013145240.GE12467@foucault.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010131657.18469.arnd@arndb.de>
X-Provags-ID: V02:K0:j0TQv4BarrNgeAPBFl3GLMakEMPXHM/ASIDqqPwenLo
 d+DXWaw5SVNlVYHBhOoi3my0UCYJTP/yx/7pGiH2XY6uKq34K1
 zi6u1XU+PTg8Y8b0wdGgw43I03TebesWACMCURiM95vNeKUmbx
 6paPehDKUsYdt9/F/B08h76SA7kmx3dWeyuTzchAQ91QfEILhM
 tE9lTWbpEcHEThB8E6NMA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 October 2010, Casey Dahlin wrote:
> So if I understand correctly, ZONE_DMA exists to separate and preserve the
> chunk of memory to which older ISA cards are capable of doing DMA. The question
> that arises for me is:
> 
> 1) Why do all 32-bit boxes have a ZONE_DMA when surely only a tiny and
> shrinking number of them have a need for it?
> 
> 2) Why do any 64-bit boxes have a ZONE_DMA? Is there really some godless
> monster out there who put an early ISA bridge and a 64-bit CPU on the same
> motherboard?!
> 
> Can someone shed light on what I'm missing?

There are some ISA devices that have become standard components, like floppy
drives. A lot of PCs still have connectors for floppies even though they
are hardly used these days.

Some architectures define ZONE_DMA in a different way, e.g. as the lower
2 GB because of device restrictions on 64 bit systems.

	Arnd
