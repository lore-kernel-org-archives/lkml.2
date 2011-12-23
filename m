Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab1LWAqC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 19:46:02 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47216 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab1LWAp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 19:45:59 -0500
MIME-Version: 1.0
In-Reply-To: <20111217144206.GF14816@konrad-lan>
References: <20111215210538.GA12248@konrad-lan>
	<CAE9FiQXFgOU3c9Ej-B_sZfhs5sRN87xE93BtZoU2K=M6=_O9YA@mail.gmail.com>
	<20111216000716.GA14822@suse.de>
	<CAE9FiQWufpJ7LwNiBnpS9bR_Sk4e5=wNZp2NmKp117+i56h=Sg@mail.gmail.com>
	<CAE9FiQXsnc5FqbhPaZLsFbZa1zz44M8k-9yP-ow814oPEEDhjQ@mail.gmail.com>
	<20111217144206.GF14816@konrad-lan>
Date: Thu, 22 Dec 2011 16:45:58 -0800
X-Google-Sender-Auth: G4UrVFVWkFtWEOwJCp7QTubxWuk
Message-ID: <CAE9FiQUvAv59UeCAyJ2h9swVmsbB6FqHzzThhbOhmvEag3WkRQ@mail.gmail.com>
Subject: Re: [GIT PULL] ibft fix for 3.2-rc6
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: Greg KH <gregkh@suse.de>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, pjones@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 17, 2011 at 6:42 AM, Konrad Rzeszutek Wilk
<konrad@darnok.org> wrote:
>>
>> but 2.6.32 base kernel still could take iscsi_ibft.c related changes
>> in the patch, and ignore conflicts with iscs_ibft_find.c.
>> but that will add new feature to 2.6.32. Not sure if stable tree
>> should take that kind of change.
>
> It could, but I am not too thrilled about it.

RHEL 6.x are still with 2.6.32...

So under UEFI mode installation, users need to input iscsi target info
again during selecting storage for installation. Because kernel does
not to parse that from acpi iBFT table.

When legacy mode iscsi installation is used, installation program will
not need user install those info again.

QA are complaining that difference.

Thanks

Yinghai Lu
