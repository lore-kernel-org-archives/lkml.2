Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab2GZR2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 13:28:37 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:26043 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab2GZR2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 13:28:36 -0400
Message-ID: <50117E40.8090904@hp.com>
Date: Thu, 26 Jul 2012 11:28:32 -0600
From: Khalid Aziz <khalid.aziz@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, mikew@google.com, tony.luck@intel.com,
        keescook@chromium.org, gong.chen@linux.intel.com, gregkh@suse.de,
        paul.gortmaker@windriver.com, maxin.john@gmail.com,
        rdunlap@xenotime.net, matt.fleming@intel.com, olof@lixom.net,
        dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Shorten constant names for EFI variable attributes
References: <20120720220841.GA32642@hp.com> <5009D770.1050905@zytor.com> <20120723132656.GC21495@srcf.ucam.org>
In-Reply-To: <20120723132656.GC21495@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2012 07:26 AM, Matthew Garrett wrote:
> On Fri, Jul 20, 2012 at 03:10:56PM -0700, H. Peter Anvin wrote:
>> On 07/20/2012 03:08 PM, Khalid Aziz wrote:
>>> Replace very long constants for EFI variable attributes
>>> with shorter and more convenient names. Also create an
>>> alias for the current longer names so as to not break
>>> compatibility with current API since these constants
>>> are used by userspace programs. This patch depends on
>>> patch <https://lkml.org/lkml/2012/7/13/313>.
>> I think these some from the EFI specifcation, so NAK IMO.
>  From the point of view of making efivars more readable, I'd certainly
> prefer shorter constant names. Keeping an alias is necessary only
> because it's an existing exposed interface. The specification doesn't
> actually require the use of these specific names anywhere, and we've
> taken a more relaxed attitude in other bits of the EFI code.
>
Matthew,

I also do not believe that kernel must use the constant names mentioned 
in the specification especially when the name reaches 50 characters. We 
can not get away from having to create aliases. Do you think having 
aliases in efi.h can cause mixed use of long names and short names in 
future code in the kernel? Can we address this by suggesting to future 
code authors that they should use the short names in their code? Should 
we consider inclusion of this patch in the kernel?

-- 
Khalid Aziz
khalid.aziz@hp.com

