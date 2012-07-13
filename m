Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933312Ab2GMOJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 10:09:10 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38666 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932722Ab2GMOJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 10:09:06 -0400
MIME-Version: 1.0
In-Reply-To: <CALbm-EbggDYBwEDmo6bjEO_=p0YEmLHASNkfAN5J-P4-mT-vgg@mail.gmail.com>
References: <CALbm-EbggDYBwEDmo6bjEO_=p0YEmLHASNkfAN5J-P4-mT-vgg@mail.gmail.com>
Date: Fri, 13 Jul 2012 10:09:04 -0400
X-Google-Sender-Auth: BcUPFIDIrnTue8za8wOVUqSqJSI
Message-ID: <CAFtxgO5=oANwXJ34rkKjWFiOxgB1hvEDToZXt=9w5gKoVOsOBw@mail.gmail.com>
Subject: Re: [PATCH] Rewrite Documentation/SubmittingPatches.
From: Jeff Garzik <jgarzik@pobox.com>
To: Stefan Beller <stefanbeller@googlemail.com>
Cc: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 7:51 AM, Stefan Beller
<stefanbeller@googlemail.com> wrote:
> This updates the documentation on how to create patches and send
> these to the kernel mailing list.
>
> The documentation before was written in times before git was there,
> so the crafting of the patch needed to be done manually by diff -up
> in the right directory.
>
> This patch aims at simplifying the patch sending process, without
> breaking the output results.
>
> A discussion with gregkh can be found at
> https://plus.google.com/111049168280159033135/posts/ekAxK9achsA
>
> Signed-off-by: Stefan Beller <stefanbeller@googlemail.com>

Speaking as the original author... seems reasonable.  ACK with
Borislav's suggested change, moving the old instructions to the bottom
of the file.
