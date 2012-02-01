Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab2BAQfN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 11:35:13 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51577 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab2BAQfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 11:35:12 -0500
Message-ID: <4F2969B7.4040202@linaro.org>
Date: Wed, 01 Feb 2012 20:35:03 +0400
From: Dmitry Antipov <dmitry.antipov@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Module/kthread/printk question/problem
References: <4F2963AA.3010306@linaro.org> <1328113899.1882.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
In-Reply-To: <1328113899.1882.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2012 08:31 PM, Eric Dumazet wrote:

> Race is here :
>
> Here you allow testmod_exit() to continue, while _this_ thread has not
> yet exited.
>
> And if this thread is preempted a litle bit, its code already was freed.
> ->  crash.

I realize this, but there was a second part of the question: what's the
better way to ensure that all test/X threads are really gone at some point of
testmod_exit()?

Thanks,
Dmitry

