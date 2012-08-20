Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab2HTQxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:53:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:36619 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514Ab2HTQx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:53:29 -0400
Message-ID: <50326B84.4010204@linutronix.de>
Date: Mon, 20 Aug 2012 18:53:24 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>,
        Jason Baron <jbaron@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH] drivers-core: beware dev_printk() from printing nonsense
References: <20120820103337.GA16744@linutronix.de> <20120820152611.GB28039@kroah.com>
In-Reply-To: <20120820152611.GB28039@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 05:26 PM, Greg Kroah-Hartman wrote:
>>   skip:
>> -	if (level[3])
>> +	if (level[sizeof(KERN_ERR) - 1])
>
> This has already been fixed in my driver-core tree and will go to Linus
> in a few hours.

Ah. So I'm too late. Care to send a patch which replace [2] with the
sizeof() operator like above?

>
> thanks,
>
> greg k-h

Sebastian
