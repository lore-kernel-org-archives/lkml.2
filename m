Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab2GaQsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 12:48:25 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49156 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab2GaQsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 12:48:24 -0400
Message-ID: <50180BF6.6080908@mvista.com>
Date: Tue, 31 Jul 2012 20:46:46 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org,
        linus.walleij@stericsson.com, arnd@arndb.de,
        broonie@opensource.wolfsonmicro.com, olalilja@yahoo.se,
        STEricsson_nomadik_linux@list.st.com, lrg@ti.com
Subject: Re: [PATCH 3/6] ARM: ux500: Fix merge error, so such struct 'snd_soc_u8500'
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org> <1343741493-17671-6-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1343741493-17671-6-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/31/2012 05:31 PM, Lee Jones wrote:

  Subject doesn't parse for me...

> The platform attempts to register platform device 'snd_soc_u8500'
> which doesn't actually exist. Here we change the reference to the
> correct one 'snd_soc_mop500'.

> Signed-off-by: Lee Jones <lee.jones@linaro.org>

WBR, Sergei


