Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab1FQIXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:23:06 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52935 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab1FQIXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:23:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=AehsLYDM2JbMphFepJQOxv0CMVldXTm4IxmaXVumxv/UT+3zVSFCCCHT9cE5c46gtA
         MmauJrCrje1Uvh4UZKxayD3REzQdxOlIYThhr/q3njlW6+D8Dj3rAq3UUbQdOx2xlcK/
         cxChJn4bgdx10hCdJ+kwC5DGOSz9IPG1Kakek=
MIME-Version: 1.0
In-Reply-To: <1307971582-13532-2-git-send-email-lars@metafoo.de>
References: <1307971582-13532-1-git-send-email-lars@metafoo.de> <1307971582-13532-2-git-send-email-lars@metafoo.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 17 Jun 2011 04:22:42 -0400
Message-ID: <BANLkTikVL=DP8jL-J9SoZY6HzX6CQ+X0XA@mail.gmail.com>
Subject: Re: [PATCH 2/3 v2] ASoC: Blackfin: Add bf5xx-adau1701 machine driver
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 09:26, Lars-Peter Clausen wrote:
> +static int bfin_eval_adau1701_probe(struct platform_device *pdev)

__devinit

seems all of the Blackfin machine drivers could use this fix ...
-mike
