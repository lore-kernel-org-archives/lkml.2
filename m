Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab2LSC7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 21:59:35 -0500
Received: from mailserver5.natinst.com ([130.164.80.5]:47806 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab2LSC7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 21:59:32 -0500
Date: Tue, 18 Dec 2012 20:59:45 -0600
From: Josh Cartwright <josh.cartwright@ni.com>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>,
        monstr@monstr.eu, John Linn <john.linn@xilinx.com>, git@xilinx.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/7] Updates for Zynq's timer driver
Message-ID: <20121219025945.GF27963@beefymiracle.amer.corp.natinst.com>
References: <bfaf054c-2b45-458e-a67f-f9d1c982ec51@TX2EHSMHS017.ehs.local>
MIME-Version: 1.0
In-Reply-To: <bfaf054c-2b45-458e-a67f-f9d1c982ec51@TX2EHSMHS017.ehs.local>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 12/18/2012 08:59:28 PM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 12/18/2012 08:59:28 PM,
	Serialize complete at 12/18/2012 08:59:28 PM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2012-12-19_02:2012-12-18,2012-12-19,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 04:16:32PM -0800, Soren Brinkmann wrote:
> I started to put some effort on syncing the Xilinx Linux tree with mainline and
> the timer driver is my first victim.
> Most commits are fixing style issues or clean up. Functionality is touched only
> in patches #2 and #7.
> 
> Some patches are present in almost identically in the Xilinx Linux tree and I
> took over 'Ackec-by' lines from those commits.
> 
> 	Soren
> 
> Soren Brinkmann (7):
>   arm: zynq: timer: Replace PSS through PS
>   arm: zynq: timer: Remove unnecessary register write
>   arm: zynq: timer: Remove unused #defines
>   arm: zynq: timer: Align columns
>   arm: zynq: timer: Remove redundant #includes
>   arm: zynq: timer: Fix comment style
>   arm: zynq: timer: Set clock_event cpumask

Hey Soren-

I had a look through this patchset and besides the stylistic nit in
patch 1, everything looks good to me.  Feel free to add my Reviewed-by.

Also, you seem to have neglected linux-arm-kernel from CC, you'll likely
want to repost there.

   Josh
