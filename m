Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab1CPN5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:57:53 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.186]:14904
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751416Ab1CPN5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:57:45 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzzz32i637h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LI5LFM-02-FFJ-02
X-M-MSG: 
Date: Wed, 16 Mar 2011 14:57:19 +0100
From: Robert Richter <robert.richter@amd.com>
To: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
CC: "mingo@elte.hu" <mingo@elte.hu>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>
Subject: Re: [patch v2 0/3] s390 hw sampling rework on comments as of Feb
 14th
Message-ID: <20110316135719.GM31407@erda.amd.com>
References: <20110216110118.316927092@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110216110118.316927092@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.02.11 06:01:18, Heinz Graalfs wrote:

> here is the second version of the rework for your comments as of February 14th.
> 
> v2:
>    - oprofile_add_ext_sample.patch
>          - introduces struct oprofile_sample_parms in include/linux/oprofile.h
>          - merges oprofile_add_ext_hw_sample() into oprofile_add_ext_sample()
>          - changes signature of oprofile_add_ext_sample() by using the proposed
>            structure containing relevant parameters
>          - changes all references of oprofile_add_ext_sample()
> 
> v1:
>    - oprofile_merge_init.patch
>          - merges hwsampler_files.c of arch/s390/oprofile into init.c
> 
>    - oprofile_parms_struct.patch
>          - introduces first version of struct oprofile_sample_parms in various
>            functions

Heinz,

I postponed patches #1 and #3 for after the merge window as both
change the fastpath which might cause a perfmormance impact.

Patch #2 I already applied.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

