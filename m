Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab2LFAvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 19:51:54 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53133 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab2LFAvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 19:51:52 -0500
MIME-Version: 1.0
In-Reply-To: <50BFE88D.1000800@zytor.com>
References: <1345739803-21017-1-git-send-email-mjg@redhat.com>
	<CAErSpo6dn_0b8Ngx9VT=ARs_UXQftEx=2Kczeqemtmo0XyKzuQ@mail.gmail.com>
	<20121203200241.GG5906@thinkpad-t410>
	<CAE9FiQVdpmmExrPrLf7HYVuo0cTY9Xjn6bWzObbuSSeQ-e1PbA@mail.gmail.com>
	<50BFE88D.1000800@zytor.com>
Date: Wed, 5 Dec 2012 16:51:50 -0800
X-Google-Sender-Auth: cuHYCmSNFusqi50fTgjNn63CEJs
Message-ID: <CAE9FiQXwZAAMkWYT8EjsewpuZ-OWqoaFscyzGS_pSuO9C3bf9A@mail.gmail.com>
Subject: Re: Use PCI ROMs from EFI boot services
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-efi@vger.kernel.org, dwmw2@infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 5, 2012 at 4:36 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/05/2012 04:15 PM, Yinghai Lu wrote:
>>
>
> I don't see why that isn't the right fix.  We copy the data into
> boot_params early in the boot; that *is* the official copy as far as the
> kernel is concerned.
>
> So this patch very much seems like The Right Thing.

it moves boot_params from __initdata  to data.
and just for using pointer to setup_data.

should add setup_data pointer instead. so will not waste (4096 - 8) bytes.

Yinghai
