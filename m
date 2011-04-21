Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750893Ab1DUEIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 00:08:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37128 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701Ab1DUEIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 00:08:18 -0400
Message-ID: <4DAFAD9F.4020809@zytor.com>
Date: Wed, 20 Apr 2011 21:07:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Clemens Ladisch <clemens@ladisch.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v2] x86: allow ZONE_DMA to be configurable
References: <alpine.DEB.2.00.1104141134260.386@chino.kir.corp.google.com> <4DA82F33.7080403@ladisch.de> <4DA8A5CE.2010004@zytor.com> <alpine.DEB.2.00.1104201929170.15661@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1104201929170.15661@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2011 07:31 PM, David Rientjes wrote:
>>
>> This isn't really a very good edit, as ZONE_DMA isn't inherently limited
>> to ISA/LPC devices (and LPC devices which do LPC-native bus mastering
>> DMA are not affected.)  ZONE_DMA is used even for some PCI devices which
>> have restrictions on the DMA address mask.
>>
> 
> Peter, do you think we can merge this patch now?  The discussion from 
> October resulted in the decision to rename CONFIG_EMBEDDED to 
> CONFIG_EXPERT and make CONFIG_GENERIC_ISA_DMA and CONFIG_ISA_DMA_API 
> configurable for x86.  That's all been done via the -mm tree and is in the 
> latest git.
> 
> We've run without ZONE_DMA for a few years without issues (and, obviously, 
> this patch) on x86.

Please address the documentation issues.  ZONE_DMA is *NOT* just for
"old ISA devices" -- there are plenty of other devices with restricted
DMA masks.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

