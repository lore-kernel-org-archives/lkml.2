Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab1J3T7q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 15:59:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53683 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab1J3T7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 15:59:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91 device tree basics
Date: Sun, 30 Oct 2011 21:57:06 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
References: <4EA69BC9.8040402@atmel.com>
In-Reply-To: <4EA69BC9.8040402@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110302057.06620.arnd@arndb.de>
X-Provags-ID: V02:K0:EcpbR2M49mfUzqD5SU0Pkyoe5MfFz1KkSn1uCAOyFiF
 p4GpX1x+i7JKmiT566bGR1DBisBFEo4RHO0OGIuUb/V6bbEzB4
 aQYL1XlL6ltVVoSDYprWj/vr2oDhCIiDEaOLf7+SpI1aH2WLZc
 Fek7zLxhVedshANuutvk0CHCo8fHOxoUWTSwsm5BBdz8jC6kfl
 oL6j/5ljevuuePuNG0XILuD2HkdBxkYyU76DtkVcHsHOVxivhi
 +0crZ3fyzSZ/jnbk+O985WHWNykRLSU8xfiVZ9mKaiJLbN8/8r
 y5LX65yvD3WzEagOn+3GqFRDi1U79NTjax6hucuVkw1KtQbIvd
 tPrVqvVfSV3VpRWN0G58=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 October 2011, Nicolas Ferre wrote:
> The following changes since commit c3b92c8787367a8bb53d57d9789b558f1295cc96:
> 
>   Linux 3.1 (2011-10-24 09:10:05 +0200)
> 
> are available in the git repository at:
>   git://github.com/at91linux/linux-at91.git for-arnd/at91-dt
> 
> They cover the basic device tree work done during the last moths around both 
> at91sam9g45 and at91sam9g20 based board. They have been review by Grant and
> Rob. More device tree related stuff is comming ;-)

Hi Nicolas,

I've pulled it into the next/dt branch, it looks all good but please try to
send stuff like this before the merge window next time, ideally much before
the merge window.

	Arnd
