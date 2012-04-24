Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab2DXNPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 09:15:31 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36026 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab2DXNPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 09:15:30 -0400
MIME-Version: 1.0
Date: Tue, 24 Apr 2012 15:15:29 +0200
Message-ID: <CACRpkdYqZrNFxj4kyMqYZk5PAcjF6-TroJ+Xq+3EVBLvo5Zg-Q@mail.gmail.com>
Subject: Tag on pinctrl
From: Linus Walleij <linus.walleij@linaro.org>
To: Dong Aisheng <B29396@freescale.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        viresh kumar <viresh.kumar@st.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A while back I created a tag:

pinctrl-mergebase-20120418

On the pinctrl tree. It contains stuff up until that date that
has since been sitting in linux-next for a while.

I do not expect to rebase these patches further. They
are based on v3.4-rc3. So I will base any further pinctrl
work on this.

I think Stephen needed to pull this into the ARM SoC tree?

Anyone else? Viresh's driver would survive without the
latest fixes and doings in pinctrl IIRC.

Yours,
Linus Walleij
