Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933151Ab2GEPj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:39:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50765 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab2GEPjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:39:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] of: address: Don't fail a lookup just because a node has no reg property
Date: Thu, 5 Jul 2012 15:38:37 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Rob Herring <robherring2@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, STEricsson_nomadik_linux@list.st.com
References: <1341498754-30445-1-git-send-email-lee.jones@linaro.org> <4FF5AB4D.6090500@gmail.com> <4FF5B004.4080100@linaro.org>
In-Reply-To: <4FF5B004.4080100@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207051538.37687.arnd@arndb.de>
X-Provags-ID: V02:K0:sTuqyEBQ5Ht4zCmJium2HLXmgYKnh39/d7pg2dKj1Ya
 U+kWGuFqiIXfbQaF0qElQZToZZ0Y0PwBPEY4Srd7tRb9vYwZ1L
 2Si6RzfmRiB0envW9va0vOsEczyeBQqsayIKVozju0Zm3DXo6U
 xwjRJ1qCssQrP4mpih92bVV8rk5f48lVq1JyhGOp2P+PVTaMtc
 VJuNyc5zEEasSWcuIjWfhZV6ofSyj+8jLIAMkm1g8d4UoueOZX
 SO900eS/pOpq/HvKyRF0d7aMznLIDoyPku5J+wwVb/h4U4Q+vx
 O4bOvSF0jTHbdPtfj7vgXlivUZ65DDnNtNXpt3ILK6y3olAmKM
 suQIH44QshkVF0bjv+Jw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 July 2012, Lee Jones wrote:
> >
> > Acked-by: Rob Herring <rob.herring@calxeda.com>
> >
> > Do you have something dependent on this or want me to apply?
> 
> I have things that require this patch yes. Please apply.

I guess Rob's question was whether you want to keep this together
with the patch that depends on it rather than him applying just
the one patch.

	Arnd
