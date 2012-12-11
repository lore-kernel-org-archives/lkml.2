Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab2LKR1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 12:27:31 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36548 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab2LKR13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 12:27:29 -0500
Message-ID: <50C77AE8.8090008@mvista.com>
Date: Tue, 11 Dec 2012 21:26:48 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] drivers/pinctrl/pinctrl-at91.c: convert kfree to devm_kfree
References: <1355223525-19165-1-git-send-email-Julia.Lawall@lip6.fr> <50C72E75.8030706@mvista.com> <alpine.DEB.2.02.1212111407570.2091@hadrien>
In-Reply-To: <alpine.DEB.2.02.1212111407570.2091@hadrien>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12/11/2012 04:08 PM, Julia Lawall wrote:

>>> From: Julia Lawall <Julia.Lawall@lip6.fr>

>>> The function at91_dt_node_to_map is ultimately called by the function
>>> pinctrl_get, which is an exported function.  Since it is possible that this
>>> function is not called from within a probe function, for safety, the kfree
>>> is converted to a devm_kfree, to both free the data and remove it from the
>>> device in a failure situation.
>>
>>> A newline is added in the call to devm_kfree to avoid exceeding the 80
>>
>>    devm_kzalloc() you mean?

> Yes, sorry.  Should I send a new patch?

   Up to the maintainer I guess...

> thanks,
> julia

WBR, Sergei


