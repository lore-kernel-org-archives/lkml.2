Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab2IDQie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 12:38:34 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51508 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757135Ab2IDQic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 12:38:32 -0400
Date: Tue, 4 Sep 2012 17:38:29 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH 10/11] acpi: Ignore acpi_rsdp kernel parameter in a
 secure boot environment
Message-ID: <20120904163829.GA23777@srcf.ucam.org>
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
 <1346774117-2277-11-git-send-email-mjg@redhat.com>
 <CAKocOONvci0Otb9wDgw6he48HkCvvhh+TMrv63AwgZLtmv4_Kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKocOONvci0Otb9wDgw6he48HkCvvhh+TMrv63AwgZLtmv4_Kg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 10:30:46AM -0600, Shuah Khan wrote:
> On Tue, Sep 4, 2012 at 9:55 AM, Matthew Garrett <mjg@redhat.com> wrote:
> > From: Josh Boyer <jwboyer@redhat.com>
> >
> > This option allows userspace to pass the RSDP address to the kernel.  This
> > could potentially be used to circumvent the secure boot trust model.
> > We ignore the setting if we don't have the CAP_SECURE_FIRMWARE capability.
> 
> Does this mean, acpi_rsdp is disabled on all current platforms that
> don't support CAP_SECURE_FIRMWARE?

No, if you're not using secure boot then you'll have 
CAP_SECURE_FIRMWARE.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
