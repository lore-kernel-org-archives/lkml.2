Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab0LIWvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 17:51:53 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:53297 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab0LIWvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 17:51:51 -0500
Date: Thu, 9 Dec 2010 22:51:42 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-acpi@vger.kernel.org, lenb@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] X86: Revamp reboot behaviour to match Windows more
	closely
Message-ID: <20101209225142.GA25215@srcf.ucam.org>
References: <1291931204-5854-1-git-send-email-mjg@redhat.com> <4D015741.7090500@zytor.com> <20101209223201.GA23894@srcf.ucam.org> <4D015914.1040009@zytor.com> <20101209223847.GA24452@srcf.ucam.org> <4D015ACF.1050105@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D015ACF.1050105@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 02:40:15PM -0800, H. Peter Anvin wrote:
> On 12/09/2010 02:38 PM, Matthew Garrett wrote:
>>> Windows doesn't get validated on old hardware.
>>
>> XP does this, and older hardware predates the version of the ACPI spec
>> that introduced this flag.
>>
>
> ACPI is very buggy on early implementations, presumably because WHQL had  
> not yet been extended to include it.  That is exactly why we combine  
> these kinds of things with a date check.

I'm afraid I don't understand your argument. The date cutoff would be on 
the order of 2001 (anything after this will have been tested with XP). 
The spec that defines this behaviour only came into existence in August 
2000, and any older hardware will be missing the flag that indicates 
that this feature is supported. It doesn't seem realistic to believe 
that there's any real body of hardware that sets the flag but otherwise 
has a broken implementation.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
