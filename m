Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab1K2FYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 00:24:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54080 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab1K2FYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 00:24:48 -0500
MIME-Version: 1.0
In-Reply-To: <1322497692-27868-5-git-send-email-lars@metafoo.de>
References: <1322497692-27868-1-git-send-email-lars@metafoo.de> <1322497692-27868-5-git-send-email-lars@metafoo.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 29 Nov 2011 00:24:27 -0500
Message-ID: <CAMjpGUcX9CsctL5Kd93R1ORv1D3Nx=iddQBSHKzMFvdhCS2NFg@mail.gmail.com>
Subject: Re: [PATCH 5/7] ASOC: AD193X: Add sysclk DAPM supply
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, drivers@analog.com,
        device-drivers-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nitpick: you've got a variety of subjects:
ASoC: AD193X: ...
ASOC: AD193X: ...
ASoC: ad193x: ...

be nice if it were consistent as it makes reading short logs easier ...
-mike
