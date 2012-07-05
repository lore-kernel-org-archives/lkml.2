Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab2GEVWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 17:22:03 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:49236 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025Ab2GEVWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 17:22:00 -0400
Message-ID: <4FF60551.6000808@stericsson.com>
Date: Thu, 5 Jul 2012 23:21:21 +0200
From: Linus Walleij <linus.walleij@stericsson.com>
Organization: ST-Ericsson SA
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>,
        Rickard ANDERSSON <rickard.andersson@stericsson.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>
Subject: Re: [PATCH 3/9] ARM: ux500: Remove AB8500 regulator register initialisation
 information
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org> <1341493572-29735-4-git-send-email-lee.jones@linaro.org> <201207051351.03115.arnd@arndb.de>
In-Reply-To: <201207051351.03115.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2012 03:51 PM, Arnd Bergmann wrote:
> On Thursday 05 July 2012, Lee Jones wrote:
>> There is no need to initialise the AB8500's regulator registers, as
>> most of this work is already carried out by framework features, so
>> we can safely remove all traces from platform code.
>>
>> Signed-off-by: Lee Jones<lee.jones@linaro.org>
> It makes sense, but this patch is basically a revert of dfa3a824d
> "mach-ux500: provide ab8500 init vector" from Bengt Jonsson, so
> it would be nice to get an Ack from him.

Bengt is on leave but I CC some other guys...

Yours,
Linus Walleij
