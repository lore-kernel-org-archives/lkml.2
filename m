Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab1CPNag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:30:36 -0400
Received: from mail-tx2.bigfish.com ([65.55.88.10]:8685 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752383Ab1CPNa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:30:28 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Mar 2011 09:30:28 EDT
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bhz32i637h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LI5JHG-02-BYD-02
X-M-MSG: 
Date: Wed, 16 Mar 2011 14:15:15 +0100
From: Robert Richter <robert.richter@amd.com>
To: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
CC: "mingo@elte.hu" <mingo@elte.hu>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Subject: Re: [patch 2/2] Remove hwsampler_files.c and merge its contents
 into init.c
Message-ID: <20110316131515.GL31407@erda.amd.com>
References: <20110215180212.334742128@linux.vnet.ibm.com>
 <20110215180928.546457180@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110215180928.546457180@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.02.11 13:02:14, Heinz Graalfs wrote:
> From: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
> 
> I've merged the contents of hwsampler_files.c into according to Robert Richter's comment.
>  
> Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
> Signed-off-by: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
> ---
>  arch/s390/oprofile/Makefile          |    2 
>  arch/s390/oprofile/hwsampler_files.c |  162 -----------------------------------
>  arch/s390/oprofile/init.c            |  161 ++++++++++++++++++++++++++++++++++
>  3 files changed, 159 insertions(+), 166 deletions(-)

Applied to oprofile/s390, thanks Heinz.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

