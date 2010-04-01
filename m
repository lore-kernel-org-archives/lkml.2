Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758907Ab0DAUYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 16:24:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33086 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758896Ab0DAUX6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 16:23:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QHhZF5iHNoVsu60iJZuD/gc2FrdHTzKTCepcepuBcxHqy61lcdJkNlfSt+mmnz4BWo
         jBqGdUULymYjpUNeRwMgsLTq39MU3f34ldEf2LWsGNnxSRzV4uv6/7LcP60pw8UqoMqh
         9/dXYWx9gj7BGGXv9YnJ9jH22vgmylQRnkE5w=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1004011313120.3707@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org>
	 <201003302316.45651.rjw@sisk.pl> <201004010313.32920.rjw@sisk.pl>
	 <alpine.LFD.2.00.1004010921550.3707@i5.linux-foundation.org>
	 <o2ma728f9f91004011007l4c3aee18p14daae06cda71e68@mail.gmail.com>
	 <alpine.LFD.2.00.1004011019270.3707@i5.linux-foundation.org>
	 <i2ga728f9f91004011053u75097a2n3706f946dfd8f6fb@mail.gmail.com>
	 <alpine.LFD.2.00.1004011313120.3707@i5.linux-foundation.org>
Date: Thu, 1 Apr 2010 16:23:56 -0400
Message-ID: <t2qa728f9f91004011323j1c390b3du38f2e7ee3b9e45a2@mail.gmail.com>
Subject: Re: [Regression, post-rc2] Commit a5ee4eb7541 breaks OpenGL on RS780 
	(was: Re: Linux 2.6.34-rc3)
From: Alex Deucher <alexdeucher@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Linux PCI <linux-pci@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Clemens Ladisch <clemens@ladisch.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       dri-devel@lists.sourceforge.net, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 1, 2010 at 4:17 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Thu, 1 Apr 2010, Alex Deucher wrote:
>>
>> What I meant to say was MSI works fine on bridges other than the
>> bridge the internal gfx lives on.  quirk_disable_msi() just disables
>> MSI on the devices on that particular bridge as far as I understand
>> it, but I'm by no means an expert on the PCI code.
>
> Yes, it disabled MSI only on devices under that bridge. But if it's the
> northbridge, that would be everything, no?
>
> But I don't know what devices those
>
>        PCI_VENDOR_ID_AMD, 0x9602,
>        PCI_VENDOR_ID_ASUSTEK, 0x9602,
>
> things are. If they are just a PCIE->PCI bridge rather than the root
> bridge, then everything looks fine to me.
>

Yup, those are just the pci to pci bridges used for the internal gfx.
Really there's only one, 0x9602, but some asus oem boards have the
vendor id wrong.

>                        Linus
>
