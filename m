Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab1JJVMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 17:12:49 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:50879 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab1JJVMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 17:12:47 -0400
Date: Tue, 11 Oct 2011 00:12:45 +0300 (EEST)
From: Aaro Koskinen <aaro.koskinen@iki.fi>
X-X-Sender: aaro@dell
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
cc: Kevin Hilman <khilman@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        tony@atomide.com
Subject: Re: [PATCH 3.1-rc3] gpio/omap: fix build error with certain OMAP1
 configs
In-Reply-To: <201110071430.14420.jkrzyszt@tis.icnet.pl>
Message-ID: <alpine.DEB.2.00.1110102356530.7624@dell>
References: <201108231342.25101.jkrzyszt@tis.icnet.pl> <87sjoshx2k.fsf@ti.com> <201110071430.14420.jkrzyszt@tis.icnet.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1937644034-1318281165=:7624"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1937644034-1318281165=:7624
Content-Type: TEXT/PLAIN; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT

Hi,

On Fri, 7 Oct 2011, Janusz Krzysztofik wrote:
> Dnia wtorek, 23 sierpnia 2011 o 19:11:47 Kevin Hilman napisał(a):
>> Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> writes:
>>> With commit f64ad1a0e21a, "gpio/omap: cleanup _set_gpio_wakeup(), remove
>>> ifdefs", access to build time conditionally omitted 'suspend_wakeup'
>>> member of the 'gpio_bank' structure has been placed unconditionally in
>>> function _set_gpio_wakeup(), which is always built. This resulted in the
>>> driver compilation broken for certain OMAP1, i.e., non-OMAP16xx,
>>> configurations.
>>>
>>> Really required or not in previously excluded cases, define this
>>> structure member unconditionally as a fix.
>>>
>>> Tested with a custom OMAP1510 only configuration.
>>>
>>> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
>>
>> Verified that this fixes a build problem when building for OMAP1
>> (730/850 only)
>>
>> Acked-by: Kevin Hilman <khilman@ti.com>

Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>

>> Grant, can you queue this as a fix for 3.1-rc?
>
> Sorry for being so late with checking this, but it looks like this patch
> never got into 3.1-rc, as it should, leaving the issue not fixed.
> Any chance for it still being pushed into 3.1?

This patch is one-liner, and still needed to get 3.1-rc9 compiled and
running on e.g. Amstrad E3, so I think it should get into 3.1.

A.
--8323329-1937644034-1318281165=:7624--
