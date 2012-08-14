Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab2HNLWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 07:22:22 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61560 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814Ab2HNLWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 07:22:20 -0400
MIME-Version: 1.0
In-Reply-To: <1344527268-5964-20-git-send-email-lee.jones@linaro.org>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
	<1344527268-5964-20-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 Aug 2012 13:22:20 +0200
Message-ID: <CACRpkdYjEi7Kefc3wW-+d=RoFx4zT9j6BjqRHy5jr6RB_=fyzg@mail.gmail.com>
Subject: Re: [PATCH 19/22] ARM: ux500: Rename db8500.dtsi to dbx5x0.dtsi to
 encompass the u9500, u8540 and u9540
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        Loic PALLARDY <loic.pallardy@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 5:47 PM, Lee Jones <lee.jones@linaro.org> wrote:

This patch has nothing to do with the other patches in this series.

Send it to the ARM SoC maintainers as a separate patch and
use git format-patch -m, because git is good at detecting renames.

Atleast move it to the beginning of the patch series.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
