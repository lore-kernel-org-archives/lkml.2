Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab2KLQN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 11:13:57 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:57742
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753346Ab2KLQN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 11:13:56 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432I4015Izz1de0h1202h1d1ah1d2ahzzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1155h)
X-WSS-ID: 0MDDUF1-02-1X0-02
X-M-MSG: 
Date: Mon, 12 Nov 2012 10:13:48 -0600
From: Jacob Shin <jacob.shin@amd.com>
To: Robert Richter <rric@kernel.org>
CC: Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH 0/4] perf, amd: Enable AMD family 15h northbridge counters
Message-ID: <20121112161348.GA7022@jshin-Toonie>
References: <1352509298-7319-1-git-send-email-jacob.shin@amd.com>
 <20121110115027.GC2777@rric.localhost>
 <20121111184426.GA5415@jshin-Toonie>
 <CABPqkBQn82ga0vKOn8bZTQD6H_mk4zmA+LFgNVRb7BjAdHZjXg@mail.gmail.com>
 <20121112142233.GA24433@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121112142233.GA24433@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 03:22:33PM +0100, Robert Richter wrote:
> Stephane,
> 
> On 12.11.12 13:24:38, Stephane Eranian wrote:
> > Anybody from AMD or formerly @ AMD care to submit a libpfm4 patch
> > to add the Fam15th NB events?
> > 
> > I'd like to avoid having to type them in manually.
> 
> Suravee may probably help you here.

Suravee is out of the office until the end of the month,

Is this necessary ASAP for this perf patchset to go upstream? If so,
I'll commit to getting a patch out for libpfm4 soon.

Otherwise, I'll ask Suravee to work on it when he gets back.

Thanks,

-Jacob

> 
> HTH
> 
> -Robert
> 

