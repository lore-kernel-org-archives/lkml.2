Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845Ab1CONbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 09:31:00 -0400
Received: from dspnet.fr ([188.165.44.67]:11599 "EHLO dspnet.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757811Ab1CONa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 09:30:59 -0400
Date: Tue, 15 Mar 2011 14:30:55 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Indan Zupancic <indan@nul.nu>, Dave Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Len Brown <lenb@kernel.org>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [Intel-gfx] [PATCH] ACPI/Intel: Rework Opregion support
Message-ID: <20110315133055.GA33193@dspnet.fr>
References: <1298404994-2907-1-git-send-email-mjg@redhat.com>
 <1300125566-29648-1-git-send-email-chris@chris-wilson.co.uk>
 <cb03c0cd31393b476e63c4e699247c91.squirrel@webmail.greenhost.nl>
 <20110315015226.GA26454@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110315015226.GA26454@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 01:52:26AM +0000, Matthew Garrett wrote:
> Now that we've got multiple consumers it's probably not helpful to move 
> the (potentially chip-specific) VBT handling to general code. We've got 
> zero documentation on how GMA500 handles VBT, and not a great deal more 
> for i915.

I'm not sure what you mean by "handles".  If you mean find it, the
gma500 driver code reads a 32-bit pointer to the opregion at offset
0xfc in the pci configuration space.  If you mean parse it, I haven't
seen anything that looked different to what the current kernel code
parses.

  OG.

