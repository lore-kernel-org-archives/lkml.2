Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030733Ab2GMRyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 13:54:31 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41780 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab2GMRya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 13:54:30 -0400
Date: Fri, 13 Jul 2012 18:54:28 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Khalid Aziz <khalid.aziz@hp.com>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com, mikew@google.com,
        keescook@chromium.org, gong.chen@linux.intel.com
Subject: Re: [PATCH] Add missing attributes to EFI variable attribute print
 out from sysfs
Message-ID: <20120713175428.GA19239@srcf.ucam.org>
References: <20120713153827.GA8007@hp.com>
 <20120713154645.GA16059@srcf.ucam.org>
 <5000604F.80804@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5000604F.80804@hp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 11:52:15AM -0600, Khalid Aziz wrote:
> EFI_VARIABLE_NON_VOLATILE			-> EFI_VAR_NV
> EFI_VARIABLE_BOOTSERVICE_ACCESS			-> EFI_VAR_BOOT
> EFI_VARIABLE_RUNTIME_ACCESS			-> EFI_VAR_RUNTIME
> EFI_VARIABLE_HARDWARE_ERROR_RECORD		-> EFI_VAR_HW_ERROR
> EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS		-> EFI_VAR_AUTH_WRITE
> EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS	-> EFI_VAR_TIMED_AUTH_WRITE
> EFI_VARIABLE_APPEND_WRITE			-> EFI_VAR_APPEND
> 
> Sounds reasonable?

Sounds great, but sadly they're exposed to userspace so changing them 
would be a problem. Adding aliases would be ugly but workable?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
