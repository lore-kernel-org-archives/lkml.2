Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab1LIVZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 16:25:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60216 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab1LIVZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 16:25:16 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Shridhar Rasal <srasal@nvidia.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        Rakesh Iyer <riyer@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 1/1] input: keyboard: Set configuration registers
Date: Fri, 09 Dec 2011 13:25:06 -0800
Message-ID: <3849551.l2KNPKMSmh@dtor-d630.eng.vmware.com>
User-Agent: KMail/4.7.3 (Linux/3.2.0-rc3+; KDE/4.7.3; x86_64; ; )
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1751860550@HQMAIL01.nvidia.com>
References: <1323415758-16822-1-git-send-email-srasal@nvidia.com> <74CDBE0F657A3D45AFBB94109FB122FF1751860550@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 09, 2011 12:10:43 PM Stephen Warren wrote:
> Shridhar Rasal wrote at Friday, December 09, 2011 12:29 AM:
> > To: dmitry.torokhov@gmail.com
> > Cc: rydberg@euromail.se; Stephen Warren; Rakesh Iyer;
> > linux-kernel@vger.kernel.org; linux- input@vger.kernel.org;
> > linux-tegra@vger.kernel.org; Shridhar Rasal Subject: [PATCH 1/1] input:
> > keyboard: Set configuration registers
> > 
> > -Set only REQUIRED row and column configuration register to
> > PROPER values to avoid continuously generating KBC input events.
> > -Use *en* field in pin_cfg, to check GPIO_x_ROW_EN register
> > should be set or clear.
> > 
> > Signed-off-by: Shridhar Rasal <srasal@nvidia.com>
> 
> I wondered if num==0 could be used instead of a new en field, but 0 is a
> valid row/column number, so no. As such,
> 
> Acked-by: Stephen Warren <swarren@nvidia.com>

Can we pass in number of pin_cfg instances in pdata and simply do not
mention unneeded pins instead?

Thanks.

-- 
Dmitry
