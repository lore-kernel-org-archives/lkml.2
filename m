Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230Ab2CTQFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:05:43 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41786 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab2CTQFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:05:40 -0400
Date: Tue, 20 Mar 2012 16:05:37 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: platform-driver-x86@vger.kernel.org,
        Corentin Chary <corentincj@iksaif.net>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/14] ACPI / Video: blacklist some samsung laptops
Message-ID: <20120320160537.GB6192@srcf.ucam.org>
References: <1332233594-13099-1-git-send-email-corentin.chary@gmail.com>
 <1332233594-13099-2-git-send-email-corentin.chary@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332233594-13099-2-git-send-email-corentin.chary@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 09:53:01AM +0100, Corentin Chary wrote:
> From: Corentin Chary <corentincj@iksaif.net>
> 
> On these laptops, the ACPI video is not functional, and very unlikely
> to be fixed by the vendor. Note that intel_backlight works for some
> of these laptops, and the backlight from samsung-laptop always work.
> 
> The good news is that newer laptops have functional ACPI video device
> and won't end up growing this list.

Are the hotkeys delivered via ACPI or via the Samsung device? If the 
latter, you can just do unregister_acpi_video() instead in the samsung 
driver and avoid having more machine-specific quirks in the ACPi code.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
