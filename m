Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab2LTAaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 19:30:11 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:19068
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751175Ab2LTAaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 19:30:06 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1de0h1202h1e76h1d1ah1d2ahzzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1155h)
X-WSS-ID: 0MFB01W-01-DPE-02
X-M-MSG: 
Date: Wed, 19 Dec 2012 18:29:54 -0600
From: Jacob Shin <jacob.shin@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
Message-ID: <20121220002954.GA10405@jshin-Toonie>
References: <50CD04F1.8020902@zytor.com>
 <0dcbce7a-d2ae-44fa-9658-81590f71ec47@email.android.com>
 <20121219220504.GA32212@jshin-Toonie>
 <50D23EE8.7030904@zytor.com>
 <20121219225155.GK24895@liondog.tnic>
 <20121219225941.GB2968@jshin-Toonie>
 <50D25AA9.3090306@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <50D25AA9.3090306@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 04:24:09PM -0800, H. Peter Anvin wrote:
> On 12/19/2012 04:07 PM, Jacob Shin wrote:
> > 
> > From what I remember, accessing memory around the memory hole (not
> > just the HT hole, but e038000000 ~ 10000000000 on our mentioned system
> > ) generated prefetches because the memory hole was marked as WB in PAT.
> > 
> > I'll take a look at the system again, try the blanket MTRR covering
> > 0xe000000000 ~ 1TB, and talk to our BIOS guys.
> > 
> 
> Yes, but do they all #MC (as opposed to, say, fetching all FFs)?

Yes, MCE every time and it was fatal.

> 
> 	-hpa
> 
> 
> 

