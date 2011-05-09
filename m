Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab1EIQCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 12:02:43 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65296 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab1EIQCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 12:02:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=t75HcLGdiCEuolYR64nEMbDkxO53bddyi5eEA7p3mYAs0ZlThYThiCZy4vWSTRK5oD
         WeTwwETqjo6wBm8lQMzW/n42QtJ1993Y/WeiBZ5mQaM18KSqhB9a93VoVSu/M8i3oOdo
         X54o9OcSKcliWfPkx7u+Yln8xUIGr8Sttp8+4=
Subject: Re: [PATCH] regulator: Use mc13xxx_reg_write instead of
 mc13xxx_reg_rmw in mc13892_sw_regulator_set_voltage
From: Liam Girdwood <lrg@kernel.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Yong Shen <yong.shen@linaro.org>,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
In-Reply-To: <20110509095628.GD22899@opensource.wolfsonmicro.com>
References: <1304934580.9600.7.camel@phoenix>
	 <20110509095628.GD22899@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 17:02:35 +0100
Message-ID: <1304956955.3192.20.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-09 at 11:56 +0200, Mark Brown wrote:
> On Mon, May 09, 2011 at 05:49:40PM +0800, Axel Lin wrote:
> > Currently, we call mc13xxx_reg_read and mc13xxx_reg_rmw for the same register.
> > This can be converted to simply a mc13xxx_reg_read and a mc13xxx_reg_write,
> > thus save a redundant register read.
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> --


Applied.

Thanks

Liam

