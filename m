Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab0DSFZQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 01:25:16 -0400
Received: from mail.codesourcery.com ([38.113.113.100]:54271 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab0DSFZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 01:25:14 -0400
Message-ID: <4BCBE920.70307@codesourcery.com>
Date: Mon, 19 Apr 2010 13:24:48 +0800
From: Jie Zhang <jie@codesourcery.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Justin Mattock <justinmattock@gmail.com>
CC: gcc@gcc.gnu.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: gcc- 4.6.0 20100416 rtmutex.c:1138:1: internal compiler error
References: <i2ydd18b0c31004182119w30322238p2ab0094f55901051@mail.gmail.com>
In-Reply-To: <i2ydd18b0c31004182119w30322238p2ab0094f55901051@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 12:19 PM, Justin Mattock wrote:
> so far I've compiled most of the system
> (glibc,Xserver,etc..)
> and not really anything has crashed and burned
> except for the kernel:
>
> kernel/rtmutex.c: At top level:
> kernel/rtmutex.c:1138:1: internal compiler error: in
> cgraph_decide_inlining_of_small_functions, at ipa-inline.c:1009
> Please submit a full bug report,
> with preprocessed source if appropriate.
> See<http://gcc.gnu.org/bugs.html>  for instructions.
> make[1]: *** [kernel/rtmutex.o] Error 1
> make: *** [kernel] Error 2
>
> any reports of this/ideas?
>
Please report a bug with a preprocessed source file in GCC's bugzilla.

-- 
Jie Zhang
CodeSourcery
(650) 331-3385 x735
