Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab1JTNoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 09:44:18 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45254 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab1JTNoR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 09:44:17 -0400
MIME-Version: 1.0
In-Reply-To: <20111020024556.GD32007@S2100-06.ap.freescale.net>
References: <1319041274-18723-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF173D51C039@HQMAIL01.nvidia.com>
	<20111020024556.GD32007@S2100-06.ap.freescale.net>
Date: Thu, 20 Oct 2011 15:44:16 +0200
Message-ID: <CACRpkdbK6bmYQbUcwxBRoq6L3YJ9yq5fQuF7zEbrStbiCrYEQQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: add a generic control interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Barry Song <21cnbao@gmail.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 4:45 AM, Shawn Guo <shawn.guo@freescale.com> wrote:

> We should not require device driver to call these APIs directly.  There
> are so many pinctrl subsystem internal details left to its users.

As explained I already have drivers that need to do this. OK they
are out-of-tree, but they do exist.

For U5500 we have a SIM card driver which sets pull down resistance
and load capacitance in response to information retrieved from the
card at runtime. This is not static or internal to pinctrl at all. How should
I solve this if pin configuration is not exposed?

Yours,
Linus Walleij
