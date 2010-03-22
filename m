Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab0CVKJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 06:09:42 -0400
Received: from mx03.syneticon.net ([78.111.66.105]:52693 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab0CVKJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 06:09:40 -0400
Message-ID: <4BA741D7.9020008@wpkg.org>
Date: Mon, 22 Mar 2010 11:09:27 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100302 Thunderbird/3.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: lacos@caesar.elte.hu
Subject: Re: better/faster kernel tarball compression
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 403804160 linux-2.6.34-rc2.tar
>   67479563 linux-2.6.34-rc2.tar.bz2
>   58452531 linux-2.6.34-rc2.tar.lz

Speaking of file sizes, xz[1] already provides better compression:

xz -k -9 linux-2.6.34-rc2.tar

     55320408 linux-2.6.34-rc2.tar.xz

xz -e -k -9 linux-2.6.34-rc2.tar

     54800808 linux-2.6.34-rc2.tar.xz

One drawback of xz is that it's not multi-threaded, much like bzip2 or 
gzip; would be great if it could be changed.

[1] http://tukaani.org/xz/


-- 
Tomasz Chmielewski
http://wpkg.org

