Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab2LFAS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 19:18:27 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:45638 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab2LFASZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 19:18:25 -0500
Date: Thu, 6 Dec 2012 00:18:19 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-efi@vger.kernel.org,
        mfleming@intel.com, dwmw2@infradead.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Use PCI ROMs from EFI boot services
Message-ID: <20121206001819.GA30527@srcf.ucam.org>
References: <1345739803-21017-1-git-send-email-mjg@redhat.com>
 <CAErSpo6dn_0b8Ngx9VT=ARs_UXQftEx=2Kczeqemtmo0XyKzuQ@mail.gmail.com>
 <20121203200241.GG5906@thinkpad-t410>
 <CAE9FiQVdpmmExrPrLf7HYVuo0cTY9Xjn6bWzObbuSSeQ-e1PbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVdpmmExrPrLf7HYVuo0cTY9Xjn6bWzObbuSSeQ-e1PbA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 04:15:56PM -0800, Yinghai Lu wrote:

> at the same time we should export setup_data into /sys, so kexec could
> append this pointer to command of
> second kernel, just like kexec append acpi_rsdp.
> That should address DavidW's concern.

Why should the kernel export data to userspace just so that that data 
can be passed back into the kernel?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
