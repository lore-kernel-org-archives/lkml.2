Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab1FQIVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:21:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59681 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757936Ab1FQIVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:21:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=nSBzanFe4okZ5Ul5Fb0JHL+1eX4qTaYdICEapNGRzWtTFdr55yDFnxZLXf5P+smWqi
         QTlJrIVB9OYBmhy/4cDJJsh7ynPcL0/JEhobYRZC6oMTujcXi12jlMasTeDXEQR5U2sr
         xk6RBN77eakDjuiA/wQ/CDKgZJJ0Dbzr1e5dY=
MIME-Version: 1.0
In-Reply-To: <1307971582-13532-1-git-send-email-lars@metafoo.de>
References: <1307971582-13532-1-git-send-email-lars@metafoo.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 17 Jun 2011 04:21:27 -0400
Message-ID: <BANLkTinh17LZFvo+haGtWn_BqEPqGCOCbQ@mail.gmail.com>
Subject: Re: [PATCH 1/3 v2] ASoC: Add ADAU1701 codec driver
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
> +static int adau1701_probe(struct snd_soc_codec *codec)

__devinit

rest looks fine to me
-mike
