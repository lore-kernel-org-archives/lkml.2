Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab2EIWIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 18:08:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40965 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162Ab2EIWIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 18:08:22 -0400
Date: Wed, 9 May 2012 15:08:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: sarah.a.sharp@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 3/5, resend] USB: adjust PCI quirk handler section
 annotations
Message-ID: <20120509220818.GB27659@kroah.com>
References: <4FAA4B1F0200007800082708@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAA4B1F0200007800082708@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 09:46:55AM +0100, Jan Beulich wrote:
> This is in preparation to adjust modpost to check section mismatches
> on most of the .pci_fixup* sections:
> 
> .pci_fixup_final is only used from .init.text, and hence can (along
> with the respective handler functions) reside in .init.*.
> 
> Several other .pci_fixup_* sections are needed only during boot and
> suspend/resume, and can therefore be moved into .init.* if
> !CONFIG_PM.
> 
> Handler (and eventual static data) section annotations need to/can be
> changed accordingly.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
