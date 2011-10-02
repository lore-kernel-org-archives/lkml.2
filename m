Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab1JBS0K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 14:26:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49804 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753831Ab1JBS0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 14:26:07 -0400
Date: Sun, 2 Oct 2011 19:26:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jassi Brar <jassisinghbrar@gmail.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: samsung: s3c-i2s-v2.c needs module.h
Message-ID: <20111002182605.GC2857@opensource.wolfsonmicro.com>
References: <1317562466.4996.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317562466.4996.2.camel@phoenix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 02, 2011 at 09:34:26PM +0800, Axel Lin wrote:
> Include <linux/module.h> to fix below build error:
> 
>   CC      sound/soc/samsung/s3c-i2s-v2.o
> sound/soc/samsung/s3c-i2s-v2.c:573: warning: data definition has no type or storage class

What tree is this for?  My primary development platform is based on this
driver, I'd expect to have noticed any build issues and I rather suspect
this isn't what you're supposed to do after all the module.h stuff has
settled down.
