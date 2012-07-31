Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab2GaOZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:25:32 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54793 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab2GaOZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:25:11 -0400
Message-ID: <5017EAC3.3080504@linaro.org>
Date: Tue, 31 Jul 2012 15:25:07 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 1/6] ASoC: dapm: If one widget fails, do not force all
 subsequent widgets to fail too
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org> <1343741493-17671-3-git-send-email-lee.jones@linaro.org> <20120731134214.GK4468@opensource.wolfsonmicro.com>
In-Reply-To: <20120731134214.GK4468@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/12 14:42, Mark Brown wrote:
> On Tue, Jul 31, 2012 at 02:31:23PM +0100, Lee Jones wrote:
>> If a list of widgets is provided and one of them fails to be added as
>> a control, the present semantics fail all subsequent widgets. A better
>> solution would be to only fail that widget, but pursue in attempting
>> to add the rest of the list.
>
> You're posting this *again* without bothering to respond to my review
> comments.


I didn't see any comments on this.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
