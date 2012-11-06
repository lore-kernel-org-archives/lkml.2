Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab2KFUsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 15:48:10 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:3753
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752773Ab2KFUsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 15:48:09 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432I4015Izz1de0h1202h1d1ah1d2ahzz17326ah8275bh8275dhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1155h)
X-WSS-ID: 0MD333Y-01-4RD-02
X-M-MSG: 
Date: Tue, 6 Nov 2012 14:47:57 -0600
From: Jacob Shin <jacob.shin@amd.com>
To: <x86@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <herrmann.der.user@googlemail.com>
Subject: Re: [PATCH 0/4] x86, cacheinfo: Use AMD topology extensions
Message-ID: <20121106204756.GA12142@jshin-Toonie>
References: <20121019085519.GC26718@alberich>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121019085519.GC26718@alberich>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 10:55:19AM +0200, Andreas Herrmann wrote:
> Hi,
> 
> Following patches modify cachinfo code to make use of AMD's topology
> extension CPUID functions. Thus (hopefully) we can avoid CPU specific
> modifications whenever cache topology changes.
> 
> Please apply.

Acked-by: Jacob Shin <jacob.shin@amd.com>



Ping ?

Any feedback ? If not could we get it into tip ?

Thank you,

> 
> 
> Thanks,
> 
> Andreas
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 

