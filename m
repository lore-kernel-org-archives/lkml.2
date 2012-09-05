Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879Ab2IEPrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 11:47:04 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37662 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab2IEPrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 11:47:01 -0400
Date: Wed, 5 Sep 2012 16:46:51 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH 07/11] kexec: Disable in a secure boot environment
Message-ID: <20120905154651.GA20059@srcf.ucam.org>
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
 <1346774117-2277-8-git-send-email-mjg@redhat.com>
 <87txvdzgur.fsf@xmission.com>
 <20120904202205.GA28903@srcf.ucam.org>
 <87r4qhwkx9.fsf@xmission.com>
 <20120904223957.50f6a3b9@pyramind.ukuu.org.uk>
 <20120904214015.GA31325@srcf.ucam.org>
 <20120905154308.GA8457@mobil.systemanalysen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120905154308.GA8457@mobil.systemanalysen.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 05:43:08PM +0200, Roland Eggner wrote:

> Jonathan Brossard:  “… We have built a generic proof of concept malware for the 
> Intel architecture,  called 'Rakshasa',  capable of infecting more than 100 
> different motherboards.  Targets are BIOS and firmware of PCI-devices.  …”
> http://www.toucan-system.com/research/blackhat2012_brossard_hardware_backdooring.pdf

Neatly avoided by the relevant UEFI platforms requiring that all 
firmware be signed.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
