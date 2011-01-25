Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab1AYWIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 17:08:39 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11299 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab1AYWIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 17:08:37 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6237"; a="71745707"
Subject: Re: [PATCH 20/32] video/msm_fb: use system_wq instead of dedicated
 workqueues
From: Carl Vanderlip <carlv@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Tejun Heo <tj@kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org,
        Stanislaw Gruszka <stf_xl@wp.pl>, linux-usb@vger.kernel.org,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-arm-msm@vger.kernel.org
In-Reply-To: <1295982976.25496.29.camel@c-dwalke-linux.qualcomm.com>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
	 <1294062595-30097-21-git-send-email-tj@kernel.org>
	 <20110103170615.GB2285@redhat.com>
	 <1294078245.18295.5.camel@c-dwalke-linux.qualcomm.com>
	 <20110125134558.GY27510@htj.dyndns.org>
	 <1295978420.25496.18.camel@c-dwalke-linux.qualcomm.com>
	 <8ya7hdsg5j0.fsf@huya.qualcomm.com>
	 <1295982976.25496.29.camel@c-dwalke-linux.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 25 Jan 2011 14:08:36 -0800
Message-ID: <1295993316.10000.6.camel@carlv-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-25 at 11:16 -0800, Daniel Walker wrote:
> On Tue, 2011-01-25 at 11:14 -0800, David Brown wrote:
> > On Tue, Jan 25 2011, Daniel Walker wrote:
> > 
> > > On Tue, 2011-01-25 at 14:45 +0100, Tejun Heo wrote:
> > >> On Mon, Jan 03, 2011 at 10:10:45AM -0800, Daniel Walker wrote:
> > >> > On Mon, 2011-01-03 at 18:06 +0100, Stanislaw Gruszka wrote:
> > >> > > On Mon, Jan 03, 2011 at 02:49:43PM +0100, Tejun Heo wrote:
> > >> > > > With cmwq, there's no reason to use separate workqueues.  Drop
> > >> > > > msmfb_info->resume_workqueue and use system_wq instead.
> > >> > > > 
> > >> > > > Signed-off-by: Tejun Heo <tj@kernel.org>
> > >> > > > Cc: Stanislaw Gruszka <stf_xl@wp.pl>
> > >> > > I'm not the right person, CC according to MAINTAINERS
> > >> > 
> > >> > ARM/QUALCOMM MSM MACHINE SUPPORT
> > >> > M:      David Brown <davidb@codeaurora.org>
> > >> > M:      Daniel Walker <dwalker@codeaurora.org>
> > >> > M:      Bryan Huntsman <bryanh@codeaurora.org>
> > >> 
> > >> Oops, sorry about that.  So how does the patch look?  Are you gonna
> > >> take it through msm tree or shall I take it?
> > >
> > > David ?
> > >
> > > Daniel
> > 
> > Is it difficult for you to test this change, Daniel?  I can pull it in
> > once we verify it still works.
> 
> Carl V. can test it, and review it I think ..
> 
> Daniel

Tested booting on MSM7X00A; appears to work fine (all I checked was that
it arrived at a buildroot login prompt).

Carl V.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

