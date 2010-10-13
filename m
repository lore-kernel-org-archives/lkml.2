Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab0JMO5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 10:57:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37443 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944Ab0JMO5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 10:57:11 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Casey Dahlin <cdahlin@redhat.com>
Subject: Re: A question about ZONE_DMA
Date: Wed, 13 Oct 2010 16:57:07 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7esata-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <20101013145240.GE12467@foucault.redhat.com>
In-Reply-To: <20101013145240.GE12467@foucault.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010131657.07187.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 13. Oktober 2010, 16:52:41 schrieb Casey Dahlin:
> Hi all,
> 
> So if I understand correctly, ZONE_DMA exists to separate and preserve the
> chunk of memory to which older ISA cards are capable of doing DMA. The question
> that arises for me is:
> 
> 1) Why do /all/ 32-bit boxes have a ZONE_DMA when surely only a tiny and
> shrinking number of them have a need for it?

You don't know before you load the module of the driver that needs it.

> 2) Why do /any/ 64-bit boxes have a ZONE_DMA? Is there really some godless
> monster out there who put an early ISA bridge and a 64-bit CPU on the same
> motherboard?!

Parports can use DMA and are generally ISA.

	Regards
		Oliver
