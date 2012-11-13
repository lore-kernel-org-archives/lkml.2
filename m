Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab2KMOMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 09:12:42 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59050 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022Ab2KMOMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 09:12:39 -0500
MIME-Version: 1.0
In-Reply-To: <1352685622.4984.0.camel@phoenix>
References: <1352685622.4984.0.camel@phoenix>
Date: Tue, 13 Nov 2012 15:12:38 +0100
Message-ID: <CACRpkdZoxdgBU7aCUOEygiuoRkX-fTOByTAOLTb-hQyWJp-QyQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] pinctrl: tegra: Make PINCTRL_TEGRA select PINMUX
 && PINCONF
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 3:00 AM, Axel Lin <axel.lin@ingics.com> wrote:

> Then we can remove "select PINMUX && PINCONF" from PINCTRL_TEGRA{20,30}.
> This simplifies the dependency.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Patch applied (unless Stephen get upset).

Yours,
Linus Walleij
