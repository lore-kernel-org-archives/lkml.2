Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab2H3QI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 12:08:59 -0400
Received: from seven.inai.de ([5.9.24.206]:47753 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961Ab2H3QI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 12:08:58 -0400
Date: Thu, 30 Aug 2012 18:08:56 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Borislav Petkov <bp@alien8.de>
cc: Andy Lutomirski <luto@amacapital.net>, Bjoern Franke <bjo@nord-west.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Which disk is ata4?
In-Reply-To: <20120830152200.GA24456@x1.osrc.amd.com>
Message-ID: <alpine.LNX.2.01.1208301808270.25988@frira.zrqbmnf.qr>
References: <CALCETrW-LFzcHYgx=thQiuTfU8RdRBrtXwE7QboWpNrjz4An4A@mail.gmail.com> <1346316580.7727.1.camel@localhost.localdomain> <CALCETrX6zZdVK9UHqstGNPAiXDbeMUMnLxtNrJ7pR=RYOP8iWw@mail.gmail.com> <20120830152200.GA24456@x1.osrc.amd.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 2012-08-30 17:22, Borislav Petkov wrote:

>On Thu, Aug 30, 2012 at 08:17:13AM -0700, Andy Lutomirski wrote:
>> $ dmesg |grep ST3000DM001-9YN166
>> [    1.064910] ata5.00: ATA-8: ST3000DM001-9YN166, CC4B, max UDMA/133
>> [    1.064926] ata3.00: ATA-8: ST3000DM001-9YN166, CC4B, max UDMA/133
>> [    1.064986] ata2.00: ATA-8: ST3000DM001-9YN166, CC4B, max UDMA/133
>> [    1.065012] ata4.00: ATA-8: ST3000DM001-9YN166, CC4B, max UDMA/133
>> [    1.235753] ata7.00: ATA-8: ST3000DM001-9YN166, CC4B, max UDMA/133
>> [    1.727000] ata8.00: ATA-8: ST3000DM001-9YN166, CC4B, max UDMA/133
>
>Shouldn't the SATA ports have actually numbers on the motherboard. And
>if so, ata4 should be the 4th port in the nomenclature... Then it is
>only about following the cable :).

That is not reliable, especially when extra PCI cards come into play.
