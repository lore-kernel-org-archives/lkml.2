Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab1BGHAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 02:00:55 -0500
Received: from adelie.canonical.com ([91.189.90.139]:50985 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab1BGHAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 02:00:54 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: Jassi Brar <jassisinghbrar@gmail.com>
Subject: Re: [RFC, PATCH 3/3] clk: add warnings for incorrect enable/prepare semantics
Date: Mon, 7 Feb 2011 15:00:30 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-generic; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        "Uwe =?utf-8?q?Kleine-K=C3=B6nig?=" <u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
References: <201102011711.31258.jeremy.kerr@canonical.com> <1297058877.800990.238556019385.3.gpush@pororo> <AANLkTinq=HieqGUFthm04F21RuLijg2mZH+eoan9p5HN@mail.gmail.com>
In-Reply-To: <AANLkTinq=HieqGUFthm04F21RuLijg2mZH+eoan9p5HN@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102071500.31276.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jassi,

> Shouldn't the prepare_count be checked against 0 ?

Yes, you're right, it should be clk->prepare_count == 0.

Will update for the next revision.

Cheers,


Jeremy
