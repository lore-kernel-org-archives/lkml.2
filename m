Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab2LFAaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 19:30:30 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58559 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab2LFAa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 19:30:28 -0500
MIME-Version: 1.0
In-Reply-To: <50BFE50C.8030008@zytor.com>
References: <1345739803-21017-1-git-send-email-mjg@redhat.com>
	<CAErSpo6dn_0b8Ngx9VT=ARs_UXQftEx=2Kczeqemtmo0XyKzuQ@mail.gmail.com>
	<20121203200241.GG5906@thinkpad-t410>
	<CAE9FiQVdpmmExrPrLf7HYVuo0cTY9Xjn6bWzObbuSSeQ-e1PbA@mail.gmail.com>
	<20121206001819.GA30527@srcf.ucam.org>
	<50BFE50C.8030008@zytor.com>
Date: Wed, 5 Dec 2012 16:30:24 -0800
X-Google-Sender-Auth: 1MyWQp50pplfy6UqFyXb4P-tpCI
Message-ID: <CAE9FiQX+M+VynyERC0W3y8rvr1tBxWnuBqJ6E-ywC_=HvJE66g@mail.gmail.com>
Subject: Re: Use PCI ROMs from EFI boot services
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-efi@vger.kernel.org, mfleming@intel.com, dwmw2@infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 5, 2012 at 4:21 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/05/2012 04:18 PM, Matthew Garrett wrote:

> Because it also needs to modify it.  Right now kexec userspace
> synthesizes struct boot_params from scratch, and does so incorrectly to
> boot.  I think we have setup_data exported via debugfs but IIRC we never
> got a strong enough use case for sysfs.

maybe we could try  to export setup_data pointer only /sys, and that
could be safe enough.
