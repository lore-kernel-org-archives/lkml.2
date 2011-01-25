Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab1AYTOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 14:14:14 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14664 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab1AYTOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 14:14:12 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6237"; a="71724268"
From: David Brown <davidb@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Tejun Heo <tj@kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-kernel@vger.kernel.org, Stanislaw Gruszka <stf_xl@wp.pl>,
        linux-usb@vger.kernel.org, Bryan Huntsman <bryanh@codeaurora.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 20/32] video/msm_fb: use system_wq instead of dedicated workqueues
In-Reply-To: <1295978420.25496.18.camel@c-dwalke-linux.qualcomm.com> (Daniel
	Walker's message of "Tue, 25 Jan 2011 10:00:20 -0800")
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
	<1294062595-30097-21-git-send-email-tj@kernel.org>
	<20110103170615.GB2285@redhat.com>
	<1294078245.18295.5.camel@c-dwalke-linux.qualcomm.com>
	<20110125134558.GY27510@htj.dyndns.org>
	<1295978420.25496.18.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
X-Hashcash: 1:20:110125:dwalker@codeaurora.org::NGSaXIbyuOb+6MqZ:0000000000000000000000000000000000000001AYj
X-Hashcash: 1:20:110125:sgruszka@redhat.com::y1zUJupHJBk8OKSU:0000000000000000000000000000000000000000002b+n
X-Hashcash: 1:20:110125:tj@kernel.org::FyZYqMOUyB9xG3Eq:00002nlj
X-Hashcash: 1:20:110125:linux-kernel@vger.kernel.org::OBXsaLIsPPtXmPcC:0000000000000000000000000000000002pr8
X-Hashcash: 1:20:110125:linux-usb@vger.kernel.org::mMRtdThVlioor2JR:0000000000000000000000000000000000004r/Z
X-Hashcash: 1:20:110125:linux-arm-msm@vger.kernel.org::50faV8kqh9AgjroS:000000000000000000000000000000006eaU
X-Hashcash: 1:20:110125:stf_xl@wp.pl::ckEL4Vfc6JMBuPHV:00000A18+
X-Hashcash: 1:20:110125:bryanh@codeaurora.org::E/rTg/YkgGDmkXSM:0000000000000000000000000000000000000000J4s3
Date: Tue, 25 Jan 2011 11:14:11 -0800
Message-ID: <8ya7hdsg5j0.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25 2011, Daniel Walker wrote:

> On Tue, 2011-01-25 at 14:45 +0100, Tejun Heo wrote:
>> On Mon, Jan 03, 2011 at 10:10:45AM -0800, Daniel Walker wrote:
>> > On Mon, 2011-01-03 at 18:06 +0100, Stanislaw Gruszka wrote:
>> > > On Mon, Jan 03, 2011 at 02:49:43PM +0100, Tejun Heo wrote:
>> > > > With cmwq, there's no reason to use separate workqueues.  Drop
>> > > > msmfb_info->resume_workqueue and use system_wq instead.
>> > > > 
>> > > > Signed-off-by: Tejun Heo <tj@kernel.org>
>> > > > Cc: Stanislaw Gruszka <stf_xl@wp.pl>
>> > > I'm not the right person, CC according to MAINTAINERS
>> > 
>> > ARM/QUALCOMM MSM MACHINE SUPPORT
>> > M:      David Brown <davidb@codeaurora.org>
>> > M:      Daniel Walker <dwalker@codeaurora.org>
>> > M:      Bryan Huntsman <bryanh@codeaurora.org>
>> 
>> Oops, sorry about that.  So how does the patch look?  Are you gonna
>> take it through msm tree or shall I take it?
>
> David ?
>
> Daniel

Is it difficult for you to test this change, Daniel?  I can pull it in
once we verify it still works.

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
