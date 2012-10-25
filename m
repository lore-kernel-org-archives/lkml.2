Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633Ab2JYWXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 18:23:38 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:53179 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075Ab2JYWXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 18:23:34 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VPS-6(z555ehz98dI9371I103dK1432Izz1202h1d1ah1d2ahzz8275bh8275dhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1155h)
X-WSS-ID: 0MCGZJ2-02-1S2-02
X-M-MSG: 
Date: Thu, 25 Oct 2012 17:23:27 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, <hpa@zytor.com>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <trini@ti.com>,
        <hpa@linux.intel.com>, <linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86, mm: Find_early_table_space based on ranges
 that are actually being mapped
Message-ID: <20121025222327.GA3736@jshin-Toonie>
References: <20121024195311.GB11779@jshin-Toonie>
 <tip-844ab6f993b1d32eb40512503d35ff6ad0c57030@git.kernel.org>
 <CAE9FiQX0MvxAsZKFwH50joR5qz1oGhbXz+BD9W-QC_BrD9zKFQ@mail.gmail.com>
 <20121025075508.GD3712@gmail.com>
 <CAE9FiQW_vuaYQbmagVnxT2DGsYc=9tNeAbdBq53sYkitPOwxSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAE9FiQW_vuaYQbmagVnxT2DGsYc=9tNeAbdBq53sYkitPOwxSQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 07:33:32AM -0700, Yinghai Lu wrote:
> On Thu, Oct 25, 2012 at 12:55 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >> > -               ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
> >> > +                       /* The first 2/4M doesn't use large pages. */
> >> > +                       if (mr[i].start < PMD_SIZE)
> >> > +                               extra += range;
> >>
> >> those three lines should be added back.
> 
> missed "not" ...
> 
> >>
> >> it just get reverted in 7b16bbf9
> >
> > Could you please send a delta patch against tip:x86/urgent?
> 
> please check attached one.

Acked-by: Jacob Shin <jacob.shin@amd.com>

Sorry about that, I just retrofitted the patch and didn't see those lines got
reverted out,

Thanks!

> 
> Thanks
> 
> Yinghai



