Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab1FITJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:09:39 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51970 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab1FITJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:09:34 -0400
Date: Thu, 9 Jun 2011 20:09:23 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Tony Luck <tony.luck@intel.com>
Cc: x86@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] efi: Fix argument types for SetVariable()
Message-ID: <20110609190922.GA1805@srcf.ucam.org>
References: <1307388985-7852-1-git-send-email-mjg@redhat.com>
 <BANLkTi=wmubWjiQ3Lw7s_iA11AoE+J3BPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=wmubWjiQ3Lw7s_iA11AoE+J3BPQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 12:02:53PM -0700, Tony Luck wrote:
> On Mon, Jun 6, 2011 at 12:36 PM, Matthew Garrett <mjg@redhat.com> wrote:
> > diff --git a/include/linux/efi.h b/include/linux/efi.h
> > index e376270..0758753 100644
> > --- a/include/linux/efi.h
> > +++ b/include/linux/efi.h
> > @@ -168,7 +168,7 @@ typedef efi_status_t efi_get_variable_t (efi_char16_t *name, efi_guid_t *vendor,
> >  typedef efi_status_t efi_get_next_variable_t (unsigned long *name_size, efi_char16_t *name,
> >                                              efi_guid_t *vendor);
> >  typedef efi_status_t efi_set_variable_t (efi_char16_t *name, efi_guid_t *vendor,
> > -                                        unsigned long attr, unsigned long data_size,
> > +                                        u32 attr, unsigned long data_size,
> >                                         void *data);
> >  typedef efi_status_t efi_get_next_high_mono_count_t (u32 *count);
> >  typedef void efi_reset_system_t (int reset_type, efi_status_t status,
> 
> x86 isn't the only user of <linux/efi.h>
> 
> Building next-20110609 I see:
> 
> arch/ia64/kernel/efi.c:578: warning: assignment from incompatible pointer type
> arch/ia64/kernel/efi.c:701: warning: assignment from incompatible pointer type

Oops. I'll follow up.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
