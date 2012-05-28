Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab2E1Ug3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 16:36:29 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:55415 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab2E1Ug1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 16:36:27 -0400
Date: Mon, 28 May 2012 22:36:56 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH EDAC v26 00/66] EDAC patches for v3.5
Message-ID: <20120528203655.GA25058@aftab.osrc.amd.com>
References: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
 <20120518164615.GY20215@aftab.osrc.amd.com>
 <4FB68A28.9090205@redhat.com>
 <20120518175336.GB20215@aftab.osrc.amd.com>
 <4FC39DB8.7080804@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC39DB8.7080804@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 12:46:00PM -0300, Mauro Carvalho Chehab wrote:
> Em 18-05-2012 14:53, Borislav Petkov escreveu:
> > On Fri, May 18, 2012 at 02:43:04PM -0300, Mauro Carvalho Chehab wrote:
> >>>>   RAS: Add a tracepoint for reporting memory controller events
> >>>
> >>> Are you kidding me?
> >>>
> >>> You want to send patches upstream which are still in review and 
> >>
> >> No, I want to post the last version of the patches and provide a
> >> clearer description of what this patch series do, before sending the
> >> git pull request when the merge window opens.
> > 
> > I'm fine with offloading some of your stuff which has been reviewed
> > and agreed upon but pushing in stuff into the merge window (it should
> > open over the weekend, my clairvoyant skills tell me) which is still in
> > review is a no-no.
> 
> I'll do a pull request for the patches that were already reviewed/discussed,
> e. g:
> 
> 59148b4 RAS: Add a tracepoint for reporting memory controller events

This one is not finished yet, sorry, I was away and I couldn't reply -
will reply to your last email about it tomorrow.

The rest should be fine.

> 4c63e95 i5400_edac: improve debug messages to better represent the filled memory
> 56435f4 edac: Cleanup the logs for i7core and sb edac drivers
> f7bd747 edac: Initialize the dimm label with the known information
> d24e447 edac: Remove the legacy EDAC ABI
> 954d5f6 x38_edac: convert driver to use the new edac ABI
> 8e96c92 tile_edac: convert driver to use the new edac ABI
> c08c7fc sb_edac: convert driver to use the new edac ABI
> 02dc07b r82600_edac: convert driver to use the new edac ABI
> 6ecaee8 ppc4xx_edac: convert driver to use the new edac ABI
> 7e2f423 pasemi_edac: convert driver to use the new edac ABI
> 73f6e30 mv64x60_edac: convert driver to use the new edac ABI
> caad9cf mpc85xx_edac: convert driver to use the new edac ABI
> bc7c482 i82975x_edac: convert driver to use the new edac ABI
> 2f782de i82875p_edac: convert driver to use the new edac ABI
> cd65cb3 i82860_edac: convert driver to use the new edac ABI
> 3340fb0 i82443bxgx_edac: convert driver to use the new edac ABI
> 8e9c3a2 i7core_edac: convert driver to use the new edac ABI
> 1881dd2 i7300_edac: convert driver to use the new edac ABI
> 462ad2d i5400_edac: convert driver to use the new edac ABI
> ed2f23e i5100_edac: convert driver to use the new edac ABI
> 7c27069 i5000_edac: convert driver to use the new edac ABI
> 6b4cacb i3200_edac: convert driver to use the new edac ABI
> 0615f9d i3000_edac: convert driver to use the new edac ABI
> 232e77b e7xxx_edac: convert driver to use the new edac ABI
> 0b58240 e752x_edac: convert driver to use the new edac ABI
> c9f3f84 cpc925_edac: convert driver to use the new edac ABI
> 7fe894e cell_edac: convert driver to use the new edac ABI
> 4d38c9c amd76x_edac: convert driver to use the new edac ABI
> 20b0b97 amd64_edac: convert driver to use the new edac ABI
> 2818904 edac: Change internal representation to work with layers
> 6608e65 edac.h: Add generic layers for describing a memory location
> b9e889c edac: rewrite edac_align_ptr()
> c3fdf60 edac: move nr_pages to dimm struct
> e2b808a edac: Don't initialize csrow's first_page & friends when not needed
> 0d5f849 edac: move dimm properties to struct dimm_info
> fa3fb69 edac: Create a dimm struct and move the labels into it

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
