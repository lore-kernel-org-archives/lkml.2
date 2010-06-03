Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658Ab0FCLqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 07:46:43 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42720 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab0FCLql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 07:46:41 -0400
Date: Thu, 3 Jun 2010 12:46:27 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       Robert Hancock <hancockrwd@gmail.com>, x86@kernel.org,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to
	pci_reboot_dmi_table.
Message-ID: <20100603114627.GA29650@srcf.ucam.org>
References: <4C06ECAA.3060708@gmail.com> <4C06ED18.2010400@gmail.com> <4C06F1DD.8060004@gmail.com> <AANLkTilQuun1jQc394YM4QZtDSVeIwh67_Np0mkRDes4@mail.gmail.com> <4C06F6EA.6090701@gmail.com> <20100603013758.GA18755@srcf.ucam.org> <AANLkTik1cjxh1ItnqBXaxNcwa6we7ccJJZny-mAOAUjD@mail.gmail.com> <4C071048.9040209@gmail.com> <20100603021851.GA19546@srcf.ucam.org> <20100603105438.7b8f3ee8@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603105438.7b8f3ee8@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 10:54:38AM +0100, Alan Cox wrote:

> At least some PCs you need to issue the reboot outb calls on the boot
> processor so the userspace tests won't be reliable.

The cf9 write is supposed to be handled by the chipset rather than via 
SMM, I believe? The SMM code I've seen for reboots seems to implement 
the actual reboot by hitting that port itself...

-- 
Matthew Garrett | mjg59@srcf.ucam.org
