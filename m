Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab2H3PVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 11:21:53 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55993 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab2H3PVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 11:21:52 -0400
Date: Thu, 30 Aug 2012 17:22:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Bjoern Franke <bjo@nord-west.org>, linux-kernel@vger.kernel.org
Subject: Re: Which disk is ata4?
Message-ID: <20120830152200.GA24456@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Andy Lutomirski <luto@amacapital.net>,
	Bjoern Franke <bjo@nord-west.org>, linux-kernel@vger.kernel.org
References: <CALCETrW-LFzcHYgx=thQiuTfU8RdRBrtXwE7QboWpNrjz4An4A@mail.gmail.com>
 <1346316580.7727.1.camel@localhost.localdomain>
 <CALCETrX6zZdVK9UHqstGNPAiXDbeMUMnLxtNrJ7pR=RYOP8iWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrX6zZdVK9UHqstGNPAiXDbeMUMnLxtNrJ7pR=RYOP8iWw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 08:17:13AM -0700, Andy Lutomirski wrote:
> $ dmesg |grep ST3000DM001-9YN166
> [    1.064910] ata5.00: ATA-8: ST3000DM001-9YN166, CC4B, max UDMA/133
> [    1.064926] ata3.00: ATA-8: ST3000DM001-9YN166, CC4B, max UDMA/133
> [    1.064986] ata2.00: ATA-8: ST3000DM001-9YN166, CC4B, max UDMA/133
> [    1.065012] ata4.00: ATA-8: ST3000DM001-9YN166, CC4B, max UDMA/133
> [    1.235753] ata7.00: ATA-8: ST3000DM001-9YN166, CC4B, max UDMA/133
> [    1.727000] ata8.00: ATA-8: ST3000DM001-9YN166, CC4B, max UDMA/133

Shouldn't the SATA ports have actually numbers on the motherboard. And
if so, ata4 should be the 4th port in the nomenclature... Then it is
only about following the cable :).

-- 
Regards/Gruss,
Boris.
