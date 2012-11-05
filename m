Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab2KEJMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 04:12:08 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48750 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab2KEJMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 04:12:03 -0500
MIME-Version: 1.0
In-Reply-To: <20121104193741.7b4ca37b@pyramind.ukuu.org.uk>
References: <1352050506-29317-1-git-send-email-matt@console-pimps.org>
	<CAHR064isMXk8qkqhBJ==9sRRP7xC_j_K5rqXApza-LNkosp5mg@mail.gmail.com>
	<20121104193741.7b4ca37b@pyramind.ukuu.org.uk>
Date: Mon, 5 Nov 2012 09:12:01 +0000
X-Google-Sender-Auth: JZplNr2ypZFiMYpKUCOhmkgIssE
Message-ID: <CAHR064jwe=diZ9B-D+-SroCW1ZevkRDMosB7uDuc2VXZkFxmdA@mail.gmail.com>
Subject: Re: [PATCH] samsung-laptop: Disable if CONFIG_EFI=y
From: Corentin Chary <corentincj@iksaif.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matt Fleming <matt@console-pimps.org>, Matthew Garrett <mjg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        Alessandro Crismani <alessandro.crismani@gmail.com>,
        Mikhail Bakhterev <mike.bakhterev@gmail.com>,
        Patrick H <kernel@feystorm.net>, Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 4, 2012 at 7:37 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Acked-by: Corentin Chary <corentin.chary@gmail.com>
>
> This is totally bogus and prevents users build a kernel which can work in
> either mode. As such its a regression.

Arg.. Sorry for that, I didn't realized that CONFIG_EFI=y was not
something rare these days.

> Do the detection check at runtime. If it was booted via EFI then don't
> grovel in places you shouldn't. Indeed its possible EFI should reserve
> those memory regions ?

I wonder how the windows driver works in this case.. Maybe they use
something completly different, and the SABI interface is still there
because nobody removed/disabled it ? In this case it's probably not a
good idea to use it on these machines since the implementation is
likely to be completly broken.

--
Corentin Chary
http://xf.iksaif.net
