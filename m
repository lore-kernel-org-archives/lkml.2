Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab1FOULc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 16:11:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53933 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab1FOUL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 16:11:28 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <20110615193734.23641.8004.stgit@ponder>
References: <20110615193734.23641.8004.stgit@ponder>
Date: Wed, 15 Jun 2011 13:11:26 -0700
Message-ID: <BANLkTim-Up4xvwBpkN-3B8HFg86G7M3TUfSQUv5Tq_0Kf15wcw@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio/tegra: Move Tegra gpio driver to drivers/gpio
From: Olof Johansson <olof@lixom.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Erik Gilling <konkers@android.com>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Colin Cross <ccross@android.com>,
        spi-devel-general@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 12:37 PM, Grant Likely
<grant.likely@secretlab.ca> wrote:
> As part of the gpio driver consolidation, this patch moves the Tegra driver
> into drivers/gpio
>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Acked-by: Olof Johansson <olof@lixom.net>

Colin said he had plans to do it, or I would already have sent this
out. Thanks for doing it! :)


-Olof
