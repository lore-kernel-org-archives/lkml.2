Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab1AYSAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 13:00:51 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33132 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab1AYSAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 13:00:49 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6237"; a="71929532"
Subject: Re: [PATCH 20/32] video/msm_fb: use system_wq instead of dedicated
 workqueues
From: Daniel Walker <dwalker@codeaurora.org>
To: Tejun Heo <tj@kernel.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org,
        Stanislaw Gruszka <stf_xl@wp.pl>, linux-usb@vger.kernel.org,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-arm-msm@vger.kernel.org
In-Reply-To: <20110125134558.GY27510@htj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
	 <1294062595-30097-21-git-send-email-tj@kernel.org>
	 <20110103170615.GB2285@redhat.com>
	 <1294078245.18295.5.camel@c-dwalke-linux.qualcomm.com>
	 <20110125134558.GY27510@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 10:00:20 -0800
Message-ID: <1295978420.25496.18.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-25 at 14:45 +0100, Tejun Heo wrote:
> On Mon, Jan 03, 2011 at 10:10:45AM -0800, Daniel Walker wrote:
> > On Mon, 2011-01-03 at 18:06 +0100, Stanislaw Gruszka wrote:
> > > On Mon, Jan 03, 2011 at 02:49:43PM +0100, Tejun Heo wrote:
> > > > With cmwq, there's no reason to use separate workqueues.  Drop
> > > > msmfb_info->resume_workqueue and use system_wq instead.
> > > > 
> > > > Signed-off-by: Tejun Heo <tj@kernel.org>
> > > > Cc: Stanislaw Gruszka <stf_xl@wp.pl>
> > > I'm not the right person, CC according to MAINTAINERS
> > 
> > ARM/QUALCOMM MSM MACHINE SUPPORT
> > M:      David Brown <davidb@codeaurora.org>
> > M:      Daniel Walker <dwalker@codeaurora.org>
> > M:      Bryan Huntsman <bryanh@codeaurora.org>
> 
> Oops, sorry about that.  So how does the patch look?  Are you gonna
> take it through msm tree or shall I take it?

David ?

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

