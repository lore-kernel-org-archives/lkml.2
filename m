Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab1BOTLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 14:11:32 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:29198 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab1BOTL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 14:11:29 -0500
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzzz32i637h668h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LGOAMW-02-Q4G-02
X-M-MSG: 
Date: Tue, 15 Feb 2011 20:11:22 +0100
From: Robert Richter <robert.richter@amd.com>
To: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
CC: "mingo@elte.hu" <mingo@elte.hu>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>
Subject: Re: [patch 0/2] delta patch - s390 hw sampling rework on comments
 as of Feb 14th
Message-ID: <20110215191122.GJ5874@erda.amd.com>
References: <20110215180212.334742128@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110215180212.334742128@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.02.11 13:02:12, Heinz Graalfs wrote:
>    It is not clear to me how you want me to merge the static functions.
> 
>    One possibility I'm seeing is to merge log_sample, op_add_code, and op_add_sample?

Yes, that's it. We don't need all this different functions that almost
do the same.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

