Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab2APVfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 16:35:16 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64237 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab2APVfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 16:35:14 -0500
MIME-Version: 1.0
In-Reply-To: <20120116212640.GA6313@srcf.ucam.org>
References: <20120109003255.GA6598@havoc.gtf.org> <CA+55aFwcBQSoWfqdT9CxV=GAr5ex0=RnqtBDFty+=_Lua2VXGw@mail.gmail.com>
 <4F12E57E.3090805@garzik.org> <1326676534.13517.3.camel@minggr>
 <1326691403.13517.21.camel@minggr> <CA+55aFzqECJjbtgyOXy_H1smh09SsfgrAuVY7hK2sC-xj1GZHg@mail.gmail.com>
 <20120116194211.2cd09fb3@pyramind.ukuu.org.uk> <CA+55aFxNcAtCmzEejS=3+_L_rp-MOBS0yLS061YgiCsFw_Mt5Q@mail.gmail.com>
 <20120116195427.64edd96f@pyramind.ukuu.org.uk> <CA+55aFzXFyHTUv=8NtSmXA2UY_qO5P=HXdGnhUmF9YoA5vpX1g@mail.gmail.com>
 <20120116212640.GA6313@srcf.ucam.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Jan 2012 13:34:53 -0800
X-Google-Sender-Auth: 6xbRKjhgJ4DYUaW6TH99d8533Q4
Message-ID: <CA+55aFw53SiHYZ29bo83iyuEG1vEz5WYcx5PWegw51Y1r8YZzA@mail.gmail.com>
Subject: Re: [git patches] libata updates for 3.3
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Lin Ming <ming.m.lin@intel.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 1:26 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>
> Macs will come up with ahci if you boot via EFI rather than the BIOS
> compatibility module.

Apparently not this one. Or there is something else subtly wrong. I
use rEFIt to boot Linux on this thing, which should mean that it
booted as an EFI image, even if the kernel itself is not natively
using EFI (or even built to care).

But maybe rEFIt does something else than I expected it to do, so who knows..

                  Linus
