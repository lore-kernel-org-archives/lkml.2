Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab1JKNDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 09:03:41 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44186 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab1JKNDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 09:03:39 -0400
Date: Tue, 11 Oct 2011 14:03:34 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <ming@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>
Subject: Re: [PATCH] x86, efi: Calling __pa() with an ioremap'd address is
 invalid
Message-ID: <20111011130333.GA4117@srcf.ucam.org>
References: <1318337645-7112-1-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318337645-7112-1-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any chance of unifying the 32 and 64-bit code here as well?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
