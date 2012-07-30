Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab2G3Gyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 02:54:32 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47911 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab2G3Gya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 02:54:30 -0400
Message-ID: <50162FA2.4010009@linaro.org>
Date: Mon, 30 Jul 2012 07:54:26 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 10/18] ARM: ux500: Enable HIGHMEM on all mop500 platforms
References: <1343393162-11938-1-git-send-email-lee.jones@linaro.org> <1343393162-11938-11-git-send-email-lee.jones@linaro.org> <20120729204516.GJ4384@opensource.wolfsonmicro.com>
In-Reply-To: <20120729204516.GJ4384@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/07/12 21:45, Mark Brown wrote:
> On Fri, Jul 27, 2012 at 01:45:54PM +0100, Lee Jones wrote:
>> The current kernel commandline for ux500 based devices includes
>> hard-coded allocations for things like mali and hwmem, which
>> actually run over lowmem. Here we enable highmem in order to
>> avoid memory corruption errors.
>
> This appears to be at best tangentially related to the rest of the
> series, are you sure it shouldn't be being sent separately as a bugfix?

Yes, it should. I'll shift it.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
