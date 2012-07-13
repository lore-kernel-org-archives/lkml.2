Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab2GMPyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 11:54:09 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:44361 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290Ab2GMPyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 11:54:07 -0400
Message-ID: <5000449C.3000505@hp.com>
Date: Fri, 13 Jul 2012 09:54:04 -0600
From: Khalid Aziz <khalid.aziz@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-kernel@vger.kernel.org, tony.luck@intel.com, mikew@google.com,
        keescook@chromium.org, gong.chen@linux.intel.com
Subject: Re: [PATCH] Add missing attributes to EFI variable attribute print
 out from sysfs
References: <20120713153827.GA8007@hp.com> <20120713154645.GA16059@srcf.ucam.org>
In-Reply-To: <20120713154645.GA16059@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2012 09:46 AM, Matthew Garrett wrote:
> On Fri, Jul 13, 2012 at 09:38:27AM -0600, Khalid Aziz wrote:
>>   	if (var->Attributes & 0x4)
>>   		str += sprintf(str, "EFI_VARIABLE_RUNTIME_ACCESS\n");
> I know you're just following the pattern of the existing code, but could
> you change these to be more like
>
> if (var->Attributes & EFI_VARIABLE_RUNTIME_ACCESS)
>
> while you're at it? I think that'd be a worthwhile cleanup.
>

That is a good suggestion. I will make the changes and send out updated 
version.

-- 
Khalid Aziz
khalid.aziz@hp.com

