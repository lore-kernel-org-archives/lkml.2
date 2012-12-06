Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab2LFSnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 13:43:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52672 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab2LFSnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 13:43:05 -0500
Message-ID: <50C0E737.2000201@zytor.com>
Date: Thu, 06 Dec 2012 10:43:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Woody Wu <narkewoody@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 8250 UART doesn't work
References: <slrnkc0jqu.4ir.narkewoody@zuhnb712.local.com>
In-Reply-To: <slrnkc0jqu.4ir.narkewoody@zuhnb712.local.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2012 11:56 PM, Woody Wu wrote:
> Hi, list
>
> Does anyone here familiar to the serial 8250 driver?
>
> I enabled two uart ports in my board definition, but the ports doesn't
> appear after I loaded the kernel (3.4.19).  I discovered, it failed at
> the UART port auto configuration stage, the exact function is
> autoconfig(...) in drivers/tty/serial/8250.c.
>

Sounds like you're using some kind of buggy UART IP... sharing which one 
might help people identify the problem, if they have seen it before.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

