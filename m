Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337Ab0G0EmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 00:42:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17614 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab0G0EmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 00:42:18 -0400
Message-ID: <4C4E6363.7060705@kernel.org>
Date: Mon, 26 Jul 2010 21:41:07 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Corey Minyard <minyard@acm.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        Myron Stowe <myron.stowe@hp.com>,
        openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipmi: Fix memleaking for add_smi when duplicating happen
References: <4C4E3575.3020203@kernel.org> <4C4E3F03.4030707@acm.org>
In-Reply-To: <4C4E3F03.4030707@acm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C4E6388.0096,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2010 07:05 PM, Corey Minyard wrote:
> Please run this through checkpatch, as it has coding style violations.

yhlu@linux-siqj:~/xx/xx/kernel/tip/linux-2.6> ./scripts/checkpatch.pl patches/ipmi_reg_size.patch
total: 0 errors, 0 warnings, 105 lines checked

patches/ipmi_reg_size.patch has no obvious style problems and is ready for submission.
yhlu@linux-siqj:~/xx/xx/kernel/tip/linux-2.6> 

> 
> Also, this patch appears to fix bugs in addition to adding the print. 
> Can we have a separate patch for that?

in the comment log, i already mentioned that. 

will separate it to twol

> 
> I'm also not clear on the reason for this.  I believe all this
> information is already available in /proc/ipmi/<if#>/params.  I don't
> think there is a strong reason to print it to the log.

then why there is printing for ACPI path and pci path?

Yinghai
