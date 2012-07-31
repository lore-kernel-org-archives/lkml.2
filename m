Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab2GaO3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:29:54 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37192 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab2GaO3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:29:51 -0400
Message-ID: <5017EBDC.6010005@linaro.org>
Date: Tue, 31 Jul 2012 15:29:48 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org,
        linus.walleij@stericsson.com, arnd@arndb.de,
        broonie@opensource.wolfsonmicro.com, olalilja@yahoo.se,
        STEricsson_nomadik_linux@list.st.com, lrg@ti.com
Subject: Re: [PATCH 5/6] ARM: ux500: Enable HIGHMEM on all mop500 platforms
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org> <1343741493-17671-10-git-send-email-lee.jones@linaro.org> <20120731135614.GR6802@n2100.arm.linux.org.uk>
In-Reply-To: <20120731135614.GR6802@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/12 14:56, Russell King - ARM Linux wrote:
> On Tue, Jul 31, 2012 at 02:31:30PM +0100, Lee Jones wrote:
>> The current kernel commandline for ux500 based devices includes
>> hard-coded allocations for things like mali and hwmem, which
>> actually run over lowmem. Here we enable highmem in order to
>> avoid memory corruption errors.
>
> Err what?  highmem should make no difference if things are being done
> correctly.
>
> In other words, your patch description is too vague to understand what
> the problem is and why you have to force highmem on - and nothing should
> _require_ highmem.

I think I must have misunderstood some advice which was recently given 
to me. I'll drop the patch.

Thanks for reviewing.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
