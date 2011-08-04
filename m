Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab1HDDFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 23:05:16 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33812 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab1HDDFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 23:05:11 -0400
Date: Thu, 4 Aug 2011 04:04:41 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: matt@console-pimps.org, linux-kernel@vger.kernel.org, fenghua.yu@intel.com,
        tony.luck@intel.com, hpa@linux.intel.com, matt.fleming@linux.intel.com,
        a.zummo@towertech.it
Subject: Re: [PATCH] x86, efi: Don't recursively acquire rtc_lock
Message-ID: <20110804030441.GA25314@srcf.ucam.org>
References: <4E3A17BD0200007800073FC5@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3A17BD0200007800073FC5@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, the rtc_lock is an implementation detail of x86, while we're 
aiming to make the EFI code as general as possible. So I can see the 
argument for moving it to the callers.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
