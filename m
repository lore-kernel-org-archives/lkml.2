Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148Ab2IDNp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 09:45:29 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:48536 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab2IDNp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 09:45:28 -0400
Date: Tue, 4 Sep 2012 14:45:18 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-efi@vger.kernel.org, mfleming@intel.com, dwmw2@infradead.org
Subject: Re: [PATCH V3 1/4] EFI: Stash ROMs if they're not in the PCI BAR
Message-ID: <20120904134518.GF18151@srcf.ucam.org>
References: <1345739803-21017-1-git-send-email-mjg@redhat.com>
 <1345739803-21017-2-git-send-email-mjg@redhat.com>
 <CAErSpo4Y=z-sP6cjJSzCtD-Gsnrm6-CWWKJpqiScv6QdbzTeyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo4Y=z-sP6cjJSzCtD-Gsnrm6-CWWKJpqiScv6QdbzTeyA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 05:44:22PM -0600, Bjorn Helgaas wrote:
> On Thu, Aug 23, 2012 at 10:36 AM, Matthew Garrett <mjg@redhat.com> wrote:
> > EFI provides support for providing PCI ROMs via means other than the ROM
> > BAR. This support vanishes after we've exited boot services, so add support
> > for stashing copies of the ROMs in setup_data if they're not otherwise
> > available.
> 
> -ENO_SIGNED_OFF_BY
> 
> I'll add it if you confirm it.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

-- 
Matthew Garrett | mjg59@srcf.ucam.org
