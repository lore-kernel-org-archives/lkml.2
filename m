Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab1LNThv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 14:37:51 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65334 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758011Ab1LNThu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 14:37:50 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF176B446FFA@HQMAIL01.nvidia.com>
References: <1323431857-8828-1-git-send-email-linus.walleij@stericsson.com>
	<010201ccba2e$9b4564e0$d1d02ea0$%park@samsung.com>
	<CACRpkdasJkhAdtBSRe4B3rWFdU67HqPKv=Nji3Xnxc2GE3misQ@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF176B446FFA@HQMAIL01.nvidia.com>
Date: Wed, 14 Dec 2011 20:37:49 +0100
Message-ID: <CACRpkdbuKrb5aVhRAxAb0oP3SQuyViYbhrcuRMDNb4Ngk9S66Q@mail.gmail.com>
Subject: Re: [PATCH v6] pinctrl: add a pin config interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Chanho Park <chanho61.park@samsung.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 4:44 PM, Stephen Warren <swarren@nvidia.com> wrote:

> I thought we already discussed making pin names mandatory,
> which seems to avoid most of Chanho's objections?

I came up with a patch that conjures pin names on the form PIN42 if no name
is passed in by the pin descriptors...

Better than disallowing passing NULL strings I think, it looks useful.

Yours,
Linus Walleij
