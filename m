Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab1JTNqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 09:46:03 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:60753 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab1JTNqC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 09:46:02 -0400
MIME-Version: 1.0
In-Reply-To: <20111020024556.GD32007@S2100-06.ap.freescale.net>
References: <1319041274-18723-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF173D51C039@HQMAIL01.nvidia.com>
	<20111020024556.GD32007@S2100-06.ap.freescale.net>
Date: Thu, 20 Oct 2011 15:46:00 +0200
Message-ID: <CACRpkdY1p=7KqBWX_yoaSGgNS5QG_BU4yNz7h0aABxwGkZcT0A@mail.gmail.com>
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

>  There
> are so many pinctrl subsystem internal details left to its users.

The idea is indeed to provide facilities to help with setting up
default configuration
for pins like we set up default pinmux maps. It's not been coded yet though,
atleast not by me :-) so just have some patience...

Linus Walleij
