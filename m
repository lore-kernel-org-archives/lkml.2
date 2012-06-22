Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123Ab2FVUxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 16:53:18 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:57651 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756219Ab2FVUxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 16:53:13 -0400
Message-ID: <4FE4DB31.4000601@free.fr>
Date: Fri, 22 Jun 2012 22:53:05 +0200
From: Bernard Pidoux <bernard.pidoux@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120318 Thunderbird/11.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bernard Pidoux <bernard.pidoux@upmc.fr>
Subject: rpc_pipefs kernel panic kernel 3.4.3
References: <F77FADB4-0415-4945-AC03-CEE36F2FEB08@upmc.fr>
In-Reply-To: <F77FADB4-0415-4945-AC03-CEE36F2FEB08@upmc.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With kernel 3.4.3 I observe a panic with mount when system boots

BUG : unable to handle kernel NULL pointer dereference at (null)
IP : [ ...] rpc_pipefs_event+0xbe/0x220 [nfs]
.......
Pid: 2056, com: Mount not taintened 3.4.3 #1 MICRO STAR INTERNATIONAL 
CO., LTD MS-7258/ MS-7258
.......
.......
.......
Kernel panic - Not sycing;: Fatal exception

Here is the screen dump :

http://dl.dropbox.com/u/42969804/rpc_pipefs_kernel_panic.JPG

I hope it can help,

Bernard Pidoux


