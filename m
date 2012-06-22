Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab2FVW4F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 18:56:05 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:32852 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702Ab2FVW4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 18:56:03 -0400
Message-ID: <4FE4F7FA.4000604@free.fr>
Date: Sat, 23 Jun 2012 00:55:54 +0200
From: Bernard Pidoux <bernard.pidoux@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120318 Thunderbird/11.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bernard Pidoux <bernard.pidoux@upmc.fr>
Subject: Re: rpc_pipefs kernel panic kernel 3.4.3
References: <F77FADB4-0415-4945-AC03-CEE36F2FEB08@upmc.fr> <4FE4DB31.4000601@free.fr>
In-Reply-To: <4FE4DB31.4000601@free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same observation with kernel 3.4.4 : kernel panic when booting at the 
same place.

Kernel 3.3.7 is ok and I will check 3.3.8.

Bernard Pidoux

On 22/06/2012 22:53, Bernard Pidoux wrote:
> Hi,
>
> With kernel 3.4.3 I observe a panic with mount when system boots
>
> BUG : unable to handle kernel NULL pointer dereference at (null)
> IP : [ ...] rpc_pipefs_event+0xbe/0x220 [nfs]
> .......
> Pid: 2056, com: Mount not taintened 3.4.3 #1 MICRO STAR INTERNATIONAL 
> CO., LTD MS-7258/ MS-7258
> .......
> .......
> .......
> Kernel panic - Not sycing;: Fatal exception
>
> Here is the screen dump :
>
> http://dl.dropbox.com/u/42969804/rpc_pipefs_kernel_panic.JPG
>
> I hope it can help,
>
> Bernard Pidoux
>
>

