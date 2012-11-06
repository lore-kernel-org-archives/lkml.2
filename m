Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab2KFJLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 04:11:00 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52973 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237Ab2KFJK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 04:10:57 -0500
Date: Tue, 6 Nov 2012 10:10:58 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: AMD A10: MCE Instruction Cache Error
Message-ID: <20121106091057.GC2090@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Alexander Holler <holler@ahsoftware.de>,
	linux-kernel@vger.kernel.org
References: <5093A592.9070605@ahsoftware.de>
 <5093D069.20901@ahsoftware.de>
 <20121103044929.GB21829@liondog.tnic>
 <5094F5C5.1000000@ahsoftware.de>
 <20121104152133.GA16116@x1.osrc.amd.com>
 <5096A3A4.8070602@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5096A3A4.8070602@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 04, 2012 at 06:19:32PM +0100, Alexander Holler wrote:
> I was remotely logged in and there aren't that many faults which
> lead to complete stand still of hw (no reset).

Right, can you retry triggering the freeze without the fglrx driver?
Simply remove it completely so that even the possibility to load it is
not there.

> But as you said I can't know, the only thing I know is that a box
> with new mb, memory and apu come to a complete stand still, and
> such shortly after I've received an emergency message which told me
> that a bit inside the cpu switched unexpected. Adding to that, the
> box did the same as what it did while it received the MCE, a backup
> from a sata-atached ssd to an usb3-hd which includes compression and
> encryption which keeps all cores at work most of the time for several
> hours.

So do you get that MCE each time you execute that same workload?

Thanks.

-- 
Regards/Gruss,
Boris.
