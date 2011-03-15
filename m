Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab1CONn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 09:43:26 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:35436 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013Ab1CONnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 09:43:24 -0400
Date: Tue, 15 Mar 2011 13:43:11 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Olivier Galibert <galibert@pobox.com>
Cc: Indan Zupancic <indan@nul.nu>, Dave Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Len Brown <lenb@kernel.org>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [Intel-gfx] [PATCH] ACPI/Intel: Rework Opregion support
Message-ID: <20110315134311.GA5892@srcf.ucam.org>
References: <1298404994-2907-1-git-send-email-mjg@redhat.com> <1300125566-29648-1-git-send-email-chris@chris-wilson.co.uk> <cb03c0cd31393b476e63c4e699247c91.squirrel@webmail.greenhost.nl> <20110315015226.GA26454@srcf.ucam.org> <20110315133055.GA33193@dspnet.fr> <20110315133240.GA5471@srcf.ucam.org> <20110315134059.GB33193@dspnet.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110315134059.GB33193@dspnet.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 02:40:59PM +0100, Olivier Galibert wrote:
> On Tue, Mar 15, 2011 at 01:32:40PM +0000, Matthew Garrett wrote:
> > Opregion is one mechanism to provide VBT - it doesn't define it.
> 
> Then let me repeat that I haven't seen anything in the VBT tables of
> the gma500-using netbook I have that didn't seem to be parsed
> correctly by the current gpu/drm/i915/intel_bios.c code and its
> friends.  Have a look at it if you want.

gma600 *certainly* has a bunch of additional functionality. It may be 
that this is code that can be split out in a reasonable manner, but 
there's been sufficient fragility here that I think doing it at this 
stage for the benefit of a driver in staging doesn't buy us a great 
deal.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
