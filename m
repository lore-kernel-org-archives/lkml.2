Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab0KPOSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:18:54 -0500
Received: from static-220-247-10-204.b-man.svips.gol.ne.jp ([220.247.10.204]:56235
	"EHLO smtp.kamineko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757920Ab0KPOSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:18:51 -0500
Date: Tue, 16 Nov 2010 23:18:50 +0900
From: Mattia Dongili <malattia@linux.it>
To: Norbert Preining <preining@logic.at>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: regression since 2.6.36: backlight in sony-laptop not working
Message-ID: <20101116141849.GB2111@kamineko.org>
References: <20101104142915.GC7650@gamma.logic.tuwien.ac.at>
 <20101110035833.GB3029@kamineko.org>
 <20101111235000.GA6651@gamma.logic.tuwien.ac.at>
 <20101112034423.GA7407@srcf.ucam.org>
 <20101112035027.GD26742@gamma.logic.tuwien.ac.at>
 <20101112035732.GB7574@srcf.ucam.org>
 <20101112042243.GE2852@kamineko.org>
 <20101112043922.GA19889@gamma.logic.tuwien.ac.at>
 <20101112121742.GA17690@kamineko.org>
 <20101116051642.GA24410@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116051642.GA24410@gamma.logic.tuwien.ac.at>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.36+ x86_64
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 02:16:42PM +0900, Norbert Preining wrote:
> On Fr, 12 Nov 2010, Mattia Dongili wrote:
> > You will need an updated input-kbd to set the scancode map.
> 
> Ouch.
> 
> > > Does that mean that 2.6.37rc is too new for the user space?
> > 
> > Maybe. Anyway if evtest reacts positively to key presses then it's a
> > userspace issue and not the driver's.
> 
> What is strange that there *WAS* a change in the kernel that triggered
> that. Old kernels still work fine. I just tried 2.6.36 and it was working.
> 
> I always thought that kernel changes should not break user space
> (well, without good reason).

it's the same as this:
https://bugzilla.kernel.org/show_bug.cgi?id=23022

-- 
mattia
:wq!
