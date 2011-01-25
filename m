Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab1AYWCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 17:02:47 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43802 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab1AYWCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 17:02:45 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6237"; a="71960686"
Subject: Re: [PATCH 1/4] msm: clock: Remove unused code and definitions
From: Daniel Walker <dwalker@codeaurora.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, David Brown <davidb@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <4D3F4609.3000808@codeaurora.org>
References: <1295927118-27591-1-git-send-email-sboyd@codeaurora.org>
	 <1295927118-27591-2-git-send-email-sboyd@codeaurora.org>
	 <1295991537.25496.49.camel@c-dwalke-linux.qualcomm.com>
	 <4D3F4609.3000808@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 14:02:17 -0800
Message-ID: <1295992937.25496.75.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-25 at 13:52 -0800, Saravana Kannan wrote:
> On 01/25/2011 01:38 PM, Daniel Walker wrote:
> > On Mon, 2011-01-24 at 19:45 -0800, Stephen Boyd wrote:
> >> Remove dead code and push out clock-7x30.h and clock-pcom.h to
> >> where they are actually used.
> >>
> >
> > I'd do two patches for this. The stuff your doing is too disconnected.
> >
> > Daniel
> >
> There is a whole bunch of unused code in the clock files and it's being 
> deleted. I don't see a point of splitting it up per file.

It's easier to review when changes aren't merged that don't related to
each other.

Daniel


-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

