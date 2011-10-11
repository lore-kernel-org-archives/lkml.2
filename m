Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab1JKQXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 12:23:15 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37166 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab1JKQXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 12:23:14 -0400
Date: Tue, 11 Oct 2011 17:23:09 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: "hpanvin@gmail.com" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <ming@elte.hu>, Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>
Subject: Re: [PATCH] x86, efi: Calling __pa() with an ioremap'd address is
 invalid
Message-ID: <20111011162309.GA8582@srcf.ucam.org>
References: <1318337645-7112-1-git-send-email-matt@console-pimps.org>
 <20111011130333.GA4117@srcf.ucam.org>
 <1318338617.4060.109.camel@mfleming-mobl1.ger.corp.intel.com>
 <df88dc7c-e404-4190-a15c-4c3ef44ed45f@email.android.com>
 <1318348689.4060.118.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318348689.4060.118.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 04:58:09PM +0100, Matt Fleming wrote:

> Maybe the extra indirection isn't that bad and no one will care? If so,
> then sure, a unified version sounds like a plan. I was just hesitant of
> changing the existing 64-bit implementation for fear of receiving
> replies like "you've now made the 64-bit path slower".

If we have UEFI calls on the fast path then I think we're already 
losing. I'd favour simplicity over performance here, personally.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
