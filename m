Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569Ab1CKRAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 12:00:17 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:43487 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab1CKRAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 12:00:15 -0500
Message-ID: <4D7A5516.5080806@eukrea.com>
Date: Fri, 11 Mar 2011 18:00:06 +0100
From: =?UTF-8?B?RXJpYyBCw6luYXJk?= <eric@eukrea.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: =?UTF-8?B?TcOhcmlvIElzaWRvcm8=?= <marioisidoro@gmail.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH n_gsm] GSM Mux in non-transparent mode
References: <1299724790.1800.135.camel@Paio>  <4D7A24CF.9070805@eukrea.com> <1299857261.4444.14.camel@Paio>
In-Reply-To: <1299857261.4444.14.camel@Paio>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mário,

On 11/03/2011 16:27, Mário Isidoro wrote:
> Hi Eric
> My GE863-Pro^3 works well without it, however, without it the control
> signals from the computer side do not seem to work correctly.
>
here without this fix, ppp gets blocked during init.

>> From my tests, without the patch, the value in modem_tx will never
> change when we send TIOCMSET commands.
>
> By the way, can you confirm if your Telit modems respect the EA bit on
> the MSC frame ?
>
I get the exact same byte sequence as you do.

Eric
