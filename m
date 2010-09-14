Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab0INUz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:55:28 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32763 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab0INUz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:55:26 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6106"; a="54340244"
Subject: Re: Importing RPC server bundle
From: Daniel Walker <dwalker@codeaurora.org>
To: David =?ISO-8859-1?Q?Lanzend=F6rfer?= <david.lanzendoerfer@o2s.ch>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <201009111516.34263.david.lanzendoerfer@o2s.ch>
References: <201009111516.34263.david.lanzendoerfer@o2s.ch>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Sep 2010 13:55:07 -0700
Message-ID: <1284497707.31975.11.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-11 at 15:16 +0200, David Lanzendörfer wrote:
> Hi
> I made finally USB gadget working by import the rpc server bundle from our
> fork[1] of the android kernel release 2.6.32.
> But GNUtoo asked me, why I imported such an old version, also of AMSS.
> So my question now to you folks:
> I can import it and make it work with a new version again,
> but I need to know, what source and place I shall take it from.
> 
> Thx in advance
> 	leviathan
> 
> [1] http://gitorious.org/htc-msm-2-6-32/leviathan-incoming/commits/msm-gnuconform


Usually we pull things from Google's tree, clean them up, then import
them potentially with some changes if needed. Is that what you mean?

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

