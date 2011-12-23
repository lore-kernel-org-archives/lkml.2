Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab1LWDu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 22:50:29 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61342 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab1LWDu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 22:50:27 -0500
MIME-Version: 1.0
Reply-To: konrad@darnok.org
In-Reply-To: <CAE9FiQUvAv59UeCAyJ2h9swVmsbB6FqHzzThhbOhmvEag3WkRQ@mail.gmail.com>
References: <20111215210538.GA12248@konrad-lan>
	<CAE9FiQXFgOU3c9Ej-B_sZfhs5sRN87xE93BtZoU2K=M6=_O9YA@mail.gmail.com>
	<20111216000716.GA14822@suse.de>
	<CAE9FiQWufpJ7LwNiBnpS9bR_Sk4e5=wNZp2NmKp117+i56h=Sg@mail.gmail.com>
	<CAE9FiQXsnc5FqbhPaZLsFbZa1zz44M8k-9yP-ow814oPEEDhjQ@mail.gmail.com>
	<20111217144206.GF14816@konrad-lan>
	<CAE9FiQUvAv59UeCAyJ2h9swVmsbB6FqHzzThhbOhmvEag3WkRQ@mail.gmail.com>
Date: Thu, 22 Dec 2011 22:50:25 -0500
X-Google-Sender-Auth: JGS6w6-OC8D24gMGLGLdZCfxWxU
Message-ID: <CAPbh3rt_Fj-OcuH1mry3aUGQa+rc-t273KtWLSiQGpN1i2FtCQ@mail.gmail.com>
Subject: Re: [GIT PULL] ibft fix for 3.2-rc6
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Greg KH <gregkh@suse.de>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, pjones@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> but that will add new feature to 2.6.32. Not sure if stable tree
>>> should take that kind of change.
>>
>> It could, but I am not too thrilled about it.
>
> RHEL 6.x are still with 2.6.32...
>

If Red Hat needs it, they can back-port it. It is not that hard for it
to be done and they are very proficient at it.

> So under UEFI mode installation, users need to input iscsi target info
> again during selecting storage for installation. Because kernel does
> not to parse that from acpi iBFT table.
>
> When legacy mode iscsi installation is used, installation program will
> not need user install those info again.
>
> QA are complaining that difference.

I think I understand your position. You are getting emails from QA
testing some hardware saying it does not work with RHEL, so you try
upstream, find the bug and fix it (awesome, thanks for doing that),
and then you want to back-port the fix so RHEL picks it up (and can
close the bug). Thr mechanism for that is by contacting the vendor
about this - either using the Program Manager to open a feature
request, or waiting for a customer to report this bug (on the Red Hat
side) and then your fix will be magically picked up.

The stable 2.6.32.x tree would require the sub-maintainer (that is me)
to sign off on supporting this in 2.6.32.x tree and I am not signing
up for it b/c I don't have the time to support it (this is after-work
hours fun stuff I do).
