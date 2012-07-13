Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab2GMPqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 11:46:52 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60457 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab2GMPqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 11:46:51 -0400
Date: Fri, 13 Jul 2012 16:46:45 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Khalid Aziz <khalid.aziz@hp.com>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com, mikew@google.com,
        keescook@chromium.org, gong.chen@linux.intel.com
Subject: Re: [PATCH] Add missing attributes to EFI variable attribute print
 out from sysfs
Message-ID: <20120713154645.GA16059@srcf.ucam.org>
References: <20120713153827.GA8007@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120713153827.GA8007@hp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 09:38:27AM -0600, Khalid Aziz wrote:
>  	if (var->Attributes & 0x4)
>  		str += sprintf(str, "EFI_VARIABLE_RUNTIME_ACCESS\n");

I know you're just following the pattern of the existing code, but could 
you change these to be more like

if (var->Attributes & EFI_VARIABLE_RUNTIME_ACCESS)

while you're at it? I think that'd be a worthwhile cleanup.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
