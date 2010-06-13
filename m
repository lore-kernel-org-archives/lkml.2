Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab0FML3f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 07:29:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:34515 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab0FML3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 07:29:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ts1uHtrXMq4IzOp9/pYhRrSvWbJwd5/miFDdwzdqiBXj8hYCrrNw54/V0mdRoznZjI
         CGPwFwSH3Tzjf/m+kHgaeDcuFuCdcEUGH/FtZMKXOtRYpO1KHXhHD7FyWBh0AcIcEs3P
         ly9ihCScQRmaroR3wFvX/jD11SiVM1CDc7r58=
Subject: Re: [PATCH v4] mmc: make sdhci work with ricoh mmc controller
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Philip Langdale <philipl@overt.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew de Quincey <adq_dvb@lidskialf.net>
In-Reply-To: <4c128b3a.51a3cc0a.3161.30ab@mx.google.com>
References: <1276283286.8557.28.camel@maxim-laptop>
	 <4c128b3a.51a3cc0a.3161.30ab@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Jun 2010 14:29:28 +0300
Message-ID: <1276428568.16701.2.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-11 at 22:15 +0300, maximlevitsky@gmail.com wrote: 
> From: Maxim Levitsky <maximlevitsky@gmail.com>
> 
> The current way of disabling it is not well tested by vendor
> and has all kinds of bugs that show up on resume from ram/disk.
> 
> Old way of disabling is still supported by
> continuing to use CONFIG_MMC_RICOH_MMC.
> 
> Based on 'http://list.drzeus.cx/pipermail/sdhci-devel/2007-December/002085.html'
> Most of the credit for this goes to Andrew de Quincey
> 
> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> CC: Andrew de Quincey <adq_dvb@lidskialf.net>
> CC: linux-mmc@vger.kernel.org <linux-mmc@vger.kernel.org>

Also, I did a lot of testing and no problems (even minor) were observed.
I think this is ready for merge.


Best regards,
Maxim Levitsky

