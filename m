Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab2C0MI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 08:08:59 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39160 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab2C0MI6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 08:08:58 -0400
Message-ID: <4F71ADD6.2060407@gmail.com>
Date: Tue, 27 Mar 2012 15:08:54 +0300
From: roma1390 <roma1390@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120207 Icedove/3.0.11
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Douglas W Jones <jones@cs.uiowa.edu>,
        Michal Nazarewicz <mnazarewicz@google.com>
Subject: Re: [PATCH 0/1] vsprintf: optimize decimal conversion (again)
References: <201203262047.17865.vda.linux@googlemail.com>
In-Reply-To: <201203262047.17865.vda.linux@googlemail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.03.26 21:47, Denys Vlasenko wrote:
> Please find test programs attached.
>
> 32-bit test programs were built using gcc 4.6.2
> 64-bit test programs were built using gcc 4.2.1
> Command line: gcc --static [-m32] -O2 -Wall test_{org,new}.c

Can't compile reference for arm:
$ arm-linux-gnueabi-gcc -O2 -Wall test_org.c -o test_org
test_org.c: In function ‘put_dec’:
test_org.c:101: error: impossible constraint in ‘asm’
test_org.c:101: error: impossible constraint in ‘asm’
test_org.c:101: error: impossible constraint in ‘asm’

