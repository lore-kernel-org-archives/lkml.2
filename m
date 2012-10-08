Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab2JHFYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 01:24:15 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:32135
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751832Ab2JHFYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 01:24:14 -0400
X-IronPort-AV: E=Sophos;i="4.80,549,1344204000"; 
   d="scan'208";a="158199493"
Date: Mon, 8 Oct 2012 07:24:11 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Ryan Mallon <rmallon@gmail.com>
cc: Julia Lawall <julia.lawall@lip6.fr>, Antti Palosaari <crope@iki.fi>,
        kernel-janitors@vger.kernel.org, shubhrajyoti@ti.com,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/13] drivers/media/tuners/qt1010.c: use macros for
 i2c_msg initialization
In-Reply-To: <50726110.5020901@gmail.com>
Message-ID: <alpine.DEB.2.02.1210080722470.1972@localhost6.localdomain6>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr> <1349624323-15584-5-git-send-email-Julia.Lawall@lip6.fr> <5071FA5D.30003@gmail.com> <alpine.DEB.2.02.1210080704440.1972@localhost6.localdomain6> <50726110.5020901@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry, I mean either:
>
> 	I2C_MSG_WRITE(priv->cfg->i2c_address, &reg, sizeof(reg)),
> 	I2C_MSG_READ(priv->cfg->i2c_address, val, sizeof(*val)),

Of course.  Sorry for not having seen that.  I can do that.

julia
