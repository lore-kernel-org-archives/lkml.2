Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab2AYNqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 08:46:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257Ab2AYNqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 08:46:35 -0500
Message-ID: <4F2007A8.2080301@redhat.com>
Date: Wed, 25 Jan 2012 11:46:16 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "Semwal, Sumit" <sumit.semwal@ti.com>, Robert Morell <rmorell@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "sumit.semwal@linaro.org" <sumit.semwal@linaro.org>
Subject: Re: [PATCH] dma-buf: Use EXPORT_SYMBOL
References: <alpine.DEB.2.00.1201061458020.18430@skynet.skynet.ie> <1326845297-6233-1-git-send-email-rmorell@nvidia.com> <1326845297-6233-2-git-send-email-rmorell@nvidia.com> <CAB2ybb-RF_JU=pFDM01PJ8kiCMrJkXAMCk2LcVqYUtEoJ_We2g@mail.gmail.com> <20120120180457.GE29824@morell.nvidia.com> <20120121173207.GF3821@phenom.ffwll.local> <CAB2ybb8YepvuKDAMBH1REYERuajmczHZvsv=ENX0SFcuagXm=Q@mail.gmail.com> <20120125123036.70b28393@pyramind.ukuu.org.uk>
In-Reply-To: <20120125123036.70b28393@pyramind.ukuu.org.uk>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 25-01-2012 10:30, Alan Cox escreveu:
>> Technically speaking, is there no way that the EXPORT_SYMBOL_GPLed
>> symbols can be used by the binary blobs, possibly with an open-sourced
>> shim which provides the buffer-sharing interface to the binary blobs?
>> Are there any reasons to not consider this approach?
> 
> The GPL requires all the code of a work is source. All of it, no shims no
> magic glue. EXPORT_SYMBOL isn't an indication you can use it for binary
> modules. The GPL licence is quite clear on what is covered.

Agreed. Such patch won't change anything. The discussions, patch reviews,
etc were under the assumption that the code will be GPL'd, plus the
subsystems that are exposed by this interface also assumes that. Any trials
to circumvent it seem to violate Kernel owner's rights.

> Since you've asked this I'm advised by my lawyer to respond to all such
> assumptions of legality of binary modules...
> 
> For a Linux kernel containing any code I own the code is under the GNU
> public license v2 (in some cases or later), I have never given permission
> for that code to be used as part of a combined or derivative work which
> contains binary chunks. I have never said that modules are somehow
> magically outside the GPL and I am doubtful that in most cases a work
> containing binary modules for a Linux kernel is compatible with the
> licensing, although I accept there may be some cases that it is.
> 
> Alan

I second Alan:
	For a Linux kernel containing any code I own the code is under the GNU
	public license v2 (in a few cases, where explicitly said GPLv2 or later 
	or dual GNU/BSD), I have never given permission for that code to be
	used as part of a combined or derivative work which contains binary chunks.

Regards,
Mauro.
