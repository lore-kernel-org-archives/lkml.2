Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab0LIWkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 17:40:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59516 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875Ab0LIWkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 17:40:20 -0500
Message-ID: <4D015ACF.1050105@zytor.com>
Date: Thu, 09 Dec 2010 14:40:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: x86@kernel.org, linux-acpi@vger.kernel.org, lenb@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] X86: Revamp reboot behaviour to match Windows more
 closely
References: <1291931204-5854-1-git-send-email-mjg@redhat.com> <4D015741.7090500@zytor.com> <20101209223201.GA23894@srcf.ucam.org> <4D015914.1040009@zytor.com> <20101209223847.GA24452@srcf.ucam.org>
In-Reply-To: <20101209223847.GA24452@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2010 02:38 PM, Matthew Garrett wrote:
> On Thu, Dec 09, 2010 at 02:32:52PM -0800, H. Peter Anvin wrote:
>> On 12/09/2010 02:32 PM, Matthew Garrett wrote:
>>> On Thu, Dec 09, 2010 at 02:25:05PM -0800, H. Peter Anvin wrote:
>>>> When this was discussed before we agreed to use ACPI reboot by default
>>>> with an ACPI cutoff date; this doesn't have any such cutoff.
>>>
>>> Windows doesn't either. Older machines simply won't have the appropriate
>>> flag set in their FADT.
>>>
>>
>> Windows doesn't get validated on old hardware.
>
> XP does this, and older hardware predates the version of the ACPI spec
> that introduced this flag.
>

ACPI is very buggy on early implementations, presumably because WHQL had 
not yet been extended to include it.  That is exactly why we combine 
these kinds of things with a date check.

	-hpa

