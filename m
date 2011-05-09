Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab1EIN4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 09:56:24 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53075 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab1EIN4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 09:56:23 -0400
Date: Mon, 9 May 2011 14:56:12 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC] Controlling the ThinkPad battery charger
Message-ID: <20110509135612.GA1873@srcf.ucam.org>
References: <BANLkTinWna2sDDjbNC5xyGX3ELROs=Wd0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinWna2sDDjbNC5xyGX3ELROs=Wd0w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 08, 2011 at 08:35:32AM -0400, Andrew Lutomirski wrote:

> I like option 2 better, since it means that a userspace tool (like
> GNOME) could learn how to operate a battery charge controller once and
> then other laptops and devices could reuse the same interface.  The
> problem is that the ACPI battery driver can't see the charge control.
> So either it would need a hook to allow per-vendor control like this
> or the power_supply class would need to recognize separate charge
> controllers.

I agree that this is preferable. One option would be to just use smapi 
and provide a hook to detach the ACPI driver, but that would potentially 
mean a certain amount of code duplication.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
