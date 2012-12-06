Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab2LFBAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 20:00:40 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:51991 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab2LFBAj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 20:00:39 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <50BFE50C.8030008@zytor.com>
References: <1345739803-21017-1-git-send-email-mjg@redhat.com> <CAErSpo6dn_0b8Ngx9VT=ARs_UXQftEx=2Kczeqemtmo0XyKzuQ@mail.gmail.com> <20121203200241.GG5906@thinkpad-t410> <CAE9FiQVdpmmExrPrLf7HYVuo0cTY9Xjn6bWzObbuSSeQ-e1PbA@mail.gmail.com> <20121206001819.GA30527@srcf.ucam.org> <50BFE50C.8030008@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: Use PCI ROMs from EFI boot services
From: Matthew Garrett <mjg59@srcf.ucam.org>
Date: Wed, 05 Dec 2012 20:00:13 -0500
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-efi@vger.kernel.org, mfleming@intel.com, dwmw2@infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Message-ID: <0e7c1b81-7572-4e4a-81c7-95ec2ce01881@email.android.com>
X-cavan-blacklisted-at: zen.spamhaus.org
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 208.54.37.202
X-SA-Exim-Mail-From: mjg59@srcf.ucam.org
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



"H. Peter Anvin" <hpa@zytor.com> wrote:

>Because it also needs to modify it.  Right now kexec userspace
>synthesizes struct boot_params from scratch, and does so incorrectly to
>boot.  I think we have setup_data exported via debugfs but IIRC we
>never
>got a strong enough use case for sysfs.

Kexec userspace needs updating every time we add functionality to setup_data? That really doesn't sound ideal. If we want to be able to pass secrets between kernels then this needs to be done in kernel space, not userland. 

-- 
Matthew Garrett | mjg59@srcf.ucam.org
