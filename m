Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab2IRNeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 09:34:24 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:45400
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757064Ab2IRNeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 09:34:21 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIzz1202h1d1ah1d2ahzz15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh1155h)
X-WSS-ID: 0MAJSD2-02-OUB-02
X-M-MSG: 
Date: Tue, 18 Sep 2012 15:34:14 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Shuah Khan <shuah.khan@hp.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Greg KH <greg@kroah.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <rob@landley.net>, <akpm@linux-foundation.org>, <bhelgaas@google.com>,
        <stern@rowland.harvard.edu>, LKML <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devel@linuxdriverproject.org>,
        <x86@kernel.org>, <shuahkhan@gmail.com>
Subject: Re: [PATCH] dma-debug: New interfaces to debug dma mapping errors
Message-ID: <20120918133414.GM2505@amd.com>
References: <1347843171.4370.13.camel@lorien2>
 <20120917133937.GC11553@phenom.dumpdata.com>
 <1347897172.3227.61.camel@lorien2>
 <20120917172317.GB15783@phenom.dumpdata.com>
 <1347921915.3227.143.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1347921915.3227.143.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 04:45:15PM -0600, Shuah Khan wrote:
> Yeah. I will firm up my ideas a bit and summarize in a day or two. Would
> like to hear your ideas as well at that time, so we can pick the one
> that works the best.

I think the best approach for this functionality is to add a flag to
'struct dma_debug_entry' which tells whether the address has been
checked with dma_mapping error or not. On unmap or driver unload you can
then check for that flag and print a warning when an unchecked address
is detected.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

