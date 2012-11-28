Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab2K1Swe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 13:52:34 -0500
Received: from www.linutronix.de ([62.245.132.108]:42124 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab2K1Swd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 13:52:33 -0500
Message-ID: <50B65D6D.1000303@linutronix.de>
Date: Wed, 28 Nov 2012 19:52:29 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>
CC: Andrzej Pietrasiewicz <andrzej.p@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Joel Becker'" <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC][PATCH] fs: configfs: programmatically create config groups
References: <1353918910-12381-1-git-send-email-andrzej.p@samsung.com> <50B39921.6090308@linutronix.de> <008101cdcc7d$2d499df0$87dcd9d0$%p@samsung.com> <50B4E364.8030704@linutronix.de> <xa1tip8ruia5.fsf@mina86.com> <50B5C821.4000406@linutronix.de> <xa1ta9u1naik.fsf@mina86.com> <50B61695.50207@linutronix.de> <xa1t1ufdn6tu.fsf@mina86.com>
In-Reply-To: <xa1t1ufdn6tu.fsf@mina86.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2012 03:24 PM, Michal Nazarewicz wrote:
> On Wed, Nov 28 2012, Sebastian Andrzej Siewior wrote:
>>              <function_name>-<common_name>
>> /functions/acm-function/
>>
>> instead of
>>              <common_name>
>> /functions/function1/
>>                        +name
>> with attribute file named "name" which contains the name of the
>> function (i.e. acm). My point is to keep "name" in the directory name
>> instead having an extra attribute.
>
> Right.  But as I've suggested:
>
> 	mkdir functions/<function-name>
> 	mkdir functions/<function-name>/<common-name>
>
> which IMO is easier to handle in kernel (no parsing) and looks nicer in
> user space.

Just posted an example. Please tell me what you think.

Sebastian
