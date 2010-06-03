Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933643Ab0FCCTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 22:19:04 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60980 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933609Ab0FCCTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 22:19:02 -0400
Date: Thu, 3 Jun 2010 03:18:51 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, x86@kernel.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to
	pci_reboot_dmi_table.
Message-ID: <20100603021851.GA19546@srcf.ucam.org>
References: <4C05F3BF.6090503@gmail.com> <AANLkTinyxtHQrsgvV0CMQZnyEelVnrpCTM05PLAj-ZYx@mail.gmail.com> <4C06ECAA.3060708@gmail.com> <4C06ED18.2010400@gmail.com> <4C06F1DD.8060004@gmail.com> <AANLkTilQuun1jQc394YM4QZtDSVeIwh67_Np0mkRDes4@mail.gmail.com> <4C06F6EA.6090701@gmail.com> <20100603013758.GA18755@srcf.ucam.org> <AANLkTik1cjxh1ItnqBXaxNcwa6we7ccJJZny-mAOAUjD@mail.gmail.com> <4C071048.9040209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C071048.9040209@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 07:15:36PM -0700, Justin P. Mattock wrote:
> as soon as I change:
>
> int main() {
> 	iopl(3);
> 	outb(6, 0xcf9);
> 	usleep(100);
> 	outb(6, 0xcf9);
> 	return 0;
> }
> (the above gave a command prompt
> with numerous tries)

Ok, so it's not that straghtforward. Sigh. There's various hacky 
workarounds we could do here, but Windows doesn't seem to do them so I 
lean towards suspecting that there's something wrong with our keyboard 
controller reboot mechanism. I'll try doing some more tracing.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
