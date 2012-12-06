Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab2LFST7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 13:19:59 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:39412 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab2LFSTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 13:19:55 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQX+aJi5XEyjfjc=K4eXLbQNqE-vd+coyt1dmuujsi_eoQ@mail.gmail.com>
References: <1345739803-21017-1-git-send-email-mjg@redhat.com>
 <CAErSpo6dn_0b8Ngx9VT=ARs_UXQftEx=2Kczeqemtmo0XyKzuQ@mail.gmail.com>
 <20121203200241.GG5906@thinkpad-t410> <CAE9FiQVdpmmExrPrLf7HYVuo0cTY9Xjn6bWzObbuSSeQ-e1PbA@mail.gmail.com>
 <50BFE88D.1000800@zytor.com> <CAE9FiQXwZAAMkWYT8EjsewpuZ-OWqoaFscyzGS_pSuO9C3bf9A@mail.gmail.com>
 <CAE9FiQX+aJi5XEyjfjc=K4eXLbQNqE-vd+coyt1dmuujsi_eoQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 6 Dec 2012 11:19:33 -0700
Message-ID: <CAErSpo7-hUbvvCYPSwtSYKMKWqu99A5H5R4004rSj5Bmv0593g@mail.gmail.com>
Subject: Re: Use PCI ROMs from EFI boot services
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-efi@vger.kernel.org, dwmw2@infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 5, 2012 at 5:52 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Wed, Dec 5, 2012 at 4:51 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Wed, Dec 5, 2012 at 4:36 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On 12/05/2012 04:15 PM, Yinghai Lu wrote:
>>>>
>>>
>>> I don't see why that isn't the right fix.  We copy the data into
>>> boot_params early in the boot; that *is* the official copy as far as the
>>> kernel is concerned.
>>>
>>> So this patch very much seems like The Right Thing.
>>
>> it moves boot_params from __initdata  to data.
>
>    should be from __initdata to bss
>
>> and just for using pointer to setup_data.
>>
>> should add setup_data pointer instead. so will not waste (4096 - 8) bytes.

I'm not following the whole discussion here, but my impression is that
what's in my -next branch is acceptable
(http://git.kernel.org/?p=linux/kernel/git/helgaas/pci.git;a=commitdiff;h=328949ff10f2e3fcb11472571294beed39488342)

If not, please explain further and provide a patch to fix it.

Bjorn
