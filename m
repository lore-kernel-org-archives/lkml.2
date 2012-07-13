Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030864Ab2GMSF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 14:05:56 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:15644 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932757Ab2GMSFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 14:05:55 -0400
Message-ID: <50006380.5050604@hp.com>
Date: Fri, 13 Jul 2012 12:05:52 -0600
From: Khalid Aziz <khalid.aziz@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-kernel@vger.kernel.org, tony.luck@intel.com, mikew@google.com,
        keescook@chromium.org, gong.chen@linux.intel.com
Subject: Re: [PATCH] Add missing attributes to EFI variable attribute print
 out from sysfs
References: <20120713153827.GA8007@hp.com> <20120713154645.GA16059@srcf.ucam.org> <5000604F.80804@hp.com> <20120713175428.GA19239@srcf.ucam.org>
In-Reply-To: <20120713175428.GA19239@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2012 11:54 AM, Matthew Garrett wrote:
> On Fri, Jul 13, 2012 at 11:52:15AM -0600, Khalid Aziz wrote:
>> EFI_VARIABLE_NON_VOLATILE			-> EFI_VAR_NV
>> EFI_VARIABLE_BOOTSERVICE_ACCESS			-> EFI_VAR_BOOT
>> EFI_VARIABLE_RUNTIME_ACCESS			-> EFI_VAR_RUNTIME
>> EFI_VARIABLE_HARDWARE_ERROR_RECORD		-> EFI_VAR_HW_ERROR
>> EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS		-> EFI_VAR_AUTH_WRITE
>> EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS	-> EFI_VAR_TIMED_AUTH_WRITE
>> EFI_VARIABLE_APPEND_WRITE			-> EFI_VAR_APPEND
>>
>> Sounds reasonable?
> Sounds great, but sadly they're exposed to userspace so changing them
> would be a problem. Adding aliases would be ugly but workable?
>

Ugly but practical. I agree with creating alias. I can work up a patch that
creates the aliases in efi.h, and replaces all uses in kernel with shorter
names. This does not change ABI or API, so existing userspace programs will
continue to work.

-- 
Khalid Aziz
khalid.aziz@hp.com

