Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab2AYMec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 07:34:32 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41508 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab2AYMea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 07:34:30 -0500
Date: Wed, 25 Jan 2012 12:30:36 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Semwal, Sumit" <sumit.semwal@ti.com>
Cc: Robert Morell <rmorell@nvidia.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "sumit.semwal@linaro.org" <sumit.semwal@linaro.org>
Subject: Re: [PATCH] dma-buf: Use EXPORT_SYMBOL
Message-ID: <20120125123036.70b28393@pyramind.ukuu.org.uk>
In-Reply-To: <CAB2ybb8YepvuKDAMBH1REYERuajmczHZvsv=ENX0SFcuagXm=Q@mail.gmail.com>
References: <alpine.DEB.2.00.1201061458020.18430@skynet.skynet.ie>
	<1326845297-6233-1-git-send-email-rmorell@nvidia.com>
	<1326845297-6233-2-git-send-email-rmorell@nvidia.com>
	<CAB2ybb-RF_JU=pFDM01PJ8kiCMrJkXAMCk2LcVqYUtEoJ_We2g@mail.gmail.com>
	<20120120180457.GE29824@morell.nvidia.com>
	<20120121173207.GF3821@phenom.ffwll.local>
	<CAB2ybb8YepvuKDAMBH1REYERuajmczHZvsv=ENX0SFcuagXm=Q@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Technically speaking, is there no way that the EXPORT_SYMBOL_GPLed
> symbols can be used by the binary blobs, possibly with an open-sourced
> shim which provides the buffer-sharing interface to the binary blobs?
> Are there any reasons to not consider this approach?

The GPL requires all the code of a work is source. All of it, no shims no
magic glue. EXPORT_SYMBOL isn't an indication you can use it for binary
modules. The GPL licence is quite clear on what is covered.

Since you've asked this I'm advised by my lawyer to respond to all such
assumptions of legality of binary modules...

For a Linux kernel containing any code I own the code is under the GNU
public license v2 (in some cases or later), I have never given permission
for that code to be used as part of a combined or derivative work which
contains binary chunks. I have never said that modules are somehow
magically outside the GPL and I am doubtful that in most cases a work
containing binary modules for a Linux kernel is compatible with the
licensing, although I accept there may be some cases that it is.

Alan
