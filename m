Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761671Ab2DLAqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 20:46:47 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:47234 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761658Ab2DLAqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 20:46:44 -0400
Date: Wed, 11 Apr 2012 20:46:38 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@oneiric
To: David Daney <ddaney.cavm@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: almost time to run my kernel source cleaning scripts again?
In-Reply-To: <4F860905.4090106@gmail.com>
Message-ID: <alpine.DEB.2.02.1204112046080.3300@oneiric>
References: <alpine.DEB.2.02.1204111700170.4733@oneiric> <4F860905.4090106@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2012, David Daney wrote:

> On 04/11/2012 02:07 PM, Robert P. J. Day wrote:
> >
> >    it's been a while so i was thinking of firing up my scripts to
> > peruse the source tree looking for oddities/inconsistencies/whatever
> > (unless someone else is already doing that).
> >
> >    one example is looking for preprocessor tests of symbols that aren't
> > defined in any Kconfig file, and i can focus on any part of the source
> > tree.  for example, if i run that script against drivers/mmc, i get:
> [...]
> >
> > > > > > > CAVIUM_OCTEON_NUM_PACKET_BUFFERS
> > drivers/staging/octeon/ethernet-defines.h:36: *
> > CONFIG_CAVIUM_OCTEON_NUM_PACKET_BUFFERS
> > drivers/staging/octeon/ethernet.c:56:#if
> > defined(CONFIG_CAVIUM_OCTEON_NUM_PACKET_BUFFERS) \
> > drivers/staging/octeon/ethernet.c:57:	&&
> > CONFIG_CAVIUM_OCTEON_NUM_PACKET_BUFFERS
> > drivers/staging/octeon/ethernet.c:58:int num_packet_buffers =
> > CONFIG_CAVIUM_OCTEON_NUM_PACKET_BUFFERS;
>
> I am aware of these and am working on fixing them.

  sorry, i wasn't trying to pick on anyone, it was just a random
example.

rday

-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
