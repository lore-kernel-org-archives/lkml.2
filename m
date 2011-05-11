Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643Ab1EKWy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 18:54:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48879 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab1EKWyY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 18:54:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WMz15hMC75j9r7xQ1Y7ZbiNHL5zUsCncRxBH8U2xRTLQqwM53KaldMJbj/+q1bp+wD
         Dx+brLVC1ngq79nlukAOOt1cYNfBrQhzn73KBaBjdQArtmYfnWLKl84KibDsDHgbvEMH
         HqgUwKgVxFPvjQmfO4SteKKY2Ba+2F+wbA+q0=
MIME-Version: 1.0
In-Reply-To: <20110511210745.GA4875@kroah.com>
References: <cover.1305103212.git.mfm@muteddisk.com>
	<56b004a084644ec7e9f632d6633aa34177a59818.1305103212.git.mfm@muteddisk.com>
	<20110511210745.GA4875@kroah.com>
Date: Wed, 11 May 2011 15:54:23 -0700
Message-ID: <BANLkTi=R7cwFGbrMiQAENS4R1BivREEh0A@mail.gmail.com>
Subject: Re: [PATCH 03/12] staging: usbip: fix header includes
From: matt mooney <mfmooney@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 2:07 PM, Greg KH <greg@kroah.com> wrote:
> On Wed, May 11, 2011 at 01:54:15AM -0700, matt mooney wrote:
>> Modify header directives to include what is needed by each file and
>> not already included in its own header.
>
> This patch didn't apply properly:
>        patching file drivers/staging/usbip/stub.h
>        patching file drivers/staging/usbip/stub_dev.c
>        patching file drivers/staging/usbip/stub_main.c
>        patching file drivers/staging/usbip/stub_rx.c
>        patching file drivers/staging/usbip/stub_tx.c
>        patching file drivers/staging/usbip/usbip_common.c
>        patching file drivers/staging/usbip/usbip_common.h
>        patching file drivers/staging/usbip/usbip_event.c
>        patching file drivers/staging/usbip/vhci.h
>        patching file drivers/staging/usbip/vhci_hcd.c
>        patching file drivers/staging/usbip/vhci_rx.c
>        patching file drivers/staging/usbip/vhci_sysfs.c
>        Hunk #1 FAILED at 17.
>        1 out of 1 hunk FAILED -- saving rejects to file drivers/staging/usbip/vhci_sysfs.c.rej
>        patching file drivers/staging/usbip/vhci_tx.c
>
> What tree did you make it against?

Hmm, this was all done on linux-next-20110510. I will rebase it onto
your staging-next tree and resend it.

-- 
GPG-Key: 9AFE00EA
