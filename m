Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab2LFBV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 20:21:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42284 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908Ab2LFBVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 20:21:55 -0500
Message-ID: <50BFF328.5030406@zytor.com>
Date: Wed, 05 Dec 2012 17:21:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-efi@vger.kernel.org, mfleming@intel.com, dwmw2@infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Use PCI ROMs from EFI boot services
References: <1345739803-21017-1-git-send-email-mjg@redhat.com> <CAErSpo6dn_0b8Ngx9VT=ARs_UXQftEx=2Kczeqemtmo0XyKzuQ@mail.gmail.com> <20121203200241.GG5906@thinkpad-t410> <CAE9FiQVdpmmExrPrLf7HYVuo0cTY9Xjn6bWzObbuSSeQ-e1PbA@mail.gmail.com> <20121206001819.GA30527@srcf.ucam.org> <50BFE50C.8030008@zytor.com> <CAE9FiQX+M+VynyERC0W3y8rvr1tBxWnuBqJ6E-ywC_=HvJE66g@mail.gmail.com> <50BFE890.5070109@zytor.com> <d8d553fb-1571-4fdc-833c-92b80e15bc25@email.android.com> <50BFEF09.9000408@zytor.com> <cd3b2e67-92af-494d-ba2d-4179ead6e06b@email.android.com>
In-Reply-To: <cd3b2e67-92af-494d-ba2d-4179ead6e06b@email.android.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2012 05:13 PM, Matthew Garrett wrote:
>
>
> "H. Peter Anvin" <hpa@zytor.com> wrote:
>
>> And that presumably would be something that cannot be exposed to root?
>> If so we may want to use one of the bits in the setup_data type field
>> as
>> a security flag, perhaps...
>
> Yeah, it needs to be hidden from root - but ideally we'd be passing it to the second kernel if we kexec. Alternative would be for it to be capability bounded to a trusted signed kexec binary if we implement Vivek's IMA-based approach.
>

Either way a security flag in the type field makes sense.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

