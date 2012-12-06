Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab2LFAWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 19:22:07 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39602 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab2LFAWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 19:22:01 -0500
MIME-Version: 1.0
In-Reply-To: <20121206001819.GA30527@srcf.ucam.org>
References: <1345739803-21017-1-git-send-email-mjg@redhat.com>
	<CAErSpo6dn_0b8Ngx9VT=ARs_UXQftEx=2Kczeqemtmo0XyKzuQ@mail.gmail.com>
	<20121203200241.GG5906@thinkpad-t410>
	<CAE9FiQVdpmmExrPrLf7HYVuo0cTY9Xjn6bWzObbuSSeQ-e1PbA@mail.gmail.com>
	<20121206001819.GA30527@srcf.ucam.org>
Date: Wed, 5 Dec 2012 16:22:00 -0800
X-Google-Sender-Auth: Ypf4WGT85vA1gpOSY2pEI6peaE4
Message-ID: <CAE9FiQXOLYL8D=-iBzg+SKnAwefP_uTHNh31UCHTSQg24VCQig@mail.gmail.com>
Subject: Re: Use PCI ROMs from EFI boot services
From: Yinghai Lu <yinghai@kernel.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-efi@vger.kernel.org,
        mfleming@intel.com, dwmw2@infradead.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 5, 2012 at 4:18 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Wed, Dec 05, 2012 at 04:15:56PM -0800, Yinghai Lu wrote:
>
>> at the same time we should export setup_data into /sys, so kexec could
>> append this pointer to command of
>> second kernel, just like kexec append acpi_rsdp.
>> That should address DavidW's concern.
>
> Why should the kernel export data to userspace just so that that data
> can be passed back into the kernel?

then how the kexeced get those info?

first kernel already reserved those info as E820_RESERVED_KERN.
and those info are for bootloader's of first kernel.
