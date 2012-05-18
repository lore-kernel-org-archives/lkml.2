Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761306Ab2ERHxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 03:53:12 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60682 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760854Ab2ERHxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 03:53:09 -0400
Message-ID: <4FB5FFE1.9030204@linaro.org>
Date: Fri, 18 May 2012 08:53:05 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/18] regulator: ab8500: Split up probe() into manageable
 pieces
References: <1337262323-27692-1-git-send-email-lee.jones@linaro.org> <1337262323-27692-10-git-send-email-lee.jones@linaro.org> <20120518073603.GC4073@opensource.wolfsonmicro.com>
In-Reply-To: <20120518073603.GC4073@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/05/12 08:36, Mark Brown wrote:
> On Thu, May 17, 2012 at 02:45:14PM +0100, Lee Jones wrote:
>> ab8500's probe() function is becoming quite large, so in the lead
>> up to Device Tree enablement which will fork the thread of execution
>> this patch splits it into 3 main areas; basic error checking will
>> remain in probe(), but regulator register initialisation and regulator
>> registration have been moved to their own functions which will
>> be called in sequence by probe() and the DT equivalent.
>
> Applied, thanks.

Thank you.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
