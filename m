Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab2LSEXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 23:23:48 -0500
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:40316
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753923Ab2LSEXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 23:23:42 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1454I1432I4015Izz1de0h1202h1e76h1d1ah1d2ahzzz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h906i1155h)
Date: Tue, 18 Dec 2012 20:23:32 -0800
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Josh Cartwright <josh.cartwright@ni.com>
CC: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        <linux-kernel@vger.kernel.org>, Michal Simek <michal.simek@xilinx.com>,
        <monstr@monstr.eu>, John Linn <john.linn@xilinx.com>, <git@xilinx.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/7] Updates for Zynq's timer driver
References: <bfaf054c-2b45-458e-a67f-f9d1c982ec51@TX2EHSMHS017.ehs.local>
 <20121219025945.GF27963@beefymiracle.amer.corp.natinst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20121219025945.GF27963@beefymiracle.amer.corp.natinst.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <32732a9b-d3a7-498f-a3d0-9f0c4f0bf8b2@CO9EHSMHS032.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

On Tue, Dec 18, 2012 at 08:59:45PM -0600, Josh Cartwright wrote:
> On Tue, Dec 18, 2012 at 04:16:32PM -0800, Soren Brinkmann wrote:
> > I started to put some effort on syncing the Xilinx Linux tree with mainline and
> > the timer driver is my first victim.
> > Most commits are fixing style issues or clean up. Functionality is touched only
> > in patches #2 and #7.
> > 
> > Some patches are present in almost identically in the Xilinx Linux tree and I
> > took over 'Ackec-by' lines from those commits.
> > 
> > 	Soren
> > 
> > Soren Brinkmann (7):
> >   arm: zynq: timer: Replace PSS through PS
> >   arm: zynq: timer: Remove unnecessary register write
> >   arm: zynq: timer: Remove unused #defines
> >   arm: zynq: timer: Align columns
> >   arm: zynq: timer: Remove redundant #includes
> >   arm: zynq: timer: Fix comment style
> >   arm: zynq: timer: Set clock_event cpumask
> 
> Hey Soren-
> 
> I had a look through this patchset and besides the stylistic nit in
> patch 1, everything looks good to me.  Feel free to add my Reviewed-by.
> 
> Also, you seem to have neglected linux-arm-kernel from CC, you'll likely
> want to repost there.
Thanks, for reviewing and the heads up. I'll add the reviewed-by lines and
repost including linux-arm-kernel.

	Soren


