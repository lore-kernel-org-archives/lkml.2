Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125Ab2JaRhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:37:34 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37822 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab2JaRhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:37:32 -0400
Date: Wed, 31 Oct 2012 17:37:28 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121031173728.GA18615@srcf.ucam.org>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
 <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
 <20121029174131.GC7580@srcf.ucam.org>
 <s5hobjia6vj.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hobjia6vj.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 06:28:16PM +0100, Takashi Iwai wrote:

> request_firmware() is used for microcode loading, too, so it's fairly
> a core part to cover, I'm afraid.
> 
> I played a bit about this yesterday.  The patch below is a proof of
> concept to (ab)use the module signing mechanism for firmware loading
> too.  Sign firmware files via scripts/sign-file, and put to
> /lib/firmware/signed directory.

That does still leave me a little uneasy as far as the microcode 
licenses go. I don't know that we can distribute signed copies of some 
of them, and we obviously can't sign at the user end.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
