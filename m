Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab1JCQxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 12:53:44 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36899 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab1JCQxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 12:53:39 -0400
Date: Mon, 3 Oct 2011 17:53:32 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        MikeWaychiso@bitmath.org
Subject: Re: [PATCH v3 10/10] x86, efi: EFI boot stub support
Message-ID: <20111003165332.GA22562@srcf.ucam.org>
References: <1315838094-2307-11-git-send-email-matt@console-pimps.org>
 <1316607036-9235-1-git-send-email-matt@console-pimps.org>
 <20110929101418.GA2215@polaris.bitmath.org>
 <1317368465.3375.6.camel@mfleming-mobl1.ger.corp.intel.com>
 <20110930111312.GA6567@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110930111312.GA6567@polaris.bitmath.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 01:13:12PM +0200, Henrik Rydberg wrote:

> No, sorry, it never worked on this machine when booting from EFI.
> AFAICT, there is no known way to control backlight either (nvidia
> 320M). If you have a similar setup, sharing findings would be most
> interesting (off-line).

Should work with current nouveau git.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
