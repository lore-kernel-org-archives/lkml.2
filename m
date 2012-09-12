Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295Ab2ILWfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 18:35:12 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:41298 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab2ILWfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 18:35:09 -0400
MIME-Version: 1.0
In-Reply-To: <20120912160306.GA16482@x1.osrc.amd.com>
References: <CAHVxiJCv+tzx4rtL2Mu0zAYEurrSwHANwvL_bpDUR7ZMXJdAyg@mail.gmail.com>
	<20120912160306.GA16482@x1.osrc.amd.com>
Date: Thu, 13 Sep 2012 06:35:08 +0800
Message-ID: <CAHVxiJCmxe5Cg1PAO4-XFYvN637jZ=Ox_LGOD6aDFABxy=Fvdw@mail.gmail.com>
Subject: Re: [PATCH]URL is unavailable
From: Leonard Tse <xiehao5@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Leonard Tse <xiehao5@gmail.com>,
        ftpadmin@kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com,
        leoli@freescale.com, triplex@zh-kernel.org, tshibata@ab.jp.nec.com,
        k-keiichi@bx.jp.nec.com, minchan.kim@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/13 Borislav Petkov <bp@alien8.de>:
> On Wed, Sep 12, 2012 at 11:51:35PM +0800, Leonard Tse wrote:
>> I found this URL "http://userweb.kernel.org/~akpm/stuff/tpp.txt" which in
>>
>> Documentation/HOWTO
>>
>> at Line 115
>> at Line 582
>>
>> is just unavailable.
>
> Dear KORG admins, what are the chances of userweb.kernel.org coming back
> online?
>
> Thanks.
>
> --
> Regards/Gruss,
> Boris.

More unavailable URLs :

grep "userweb.kernel.org" . -r
./drivers/input/mouse/Kconfig:
http://userweb.kernel.org/~dtor/synaptics-no-abspressure.patch
./drivers/input/evdev.c:
"http://userweb.kernel.org/~dtor/eviocgbit-bug.html\n",
./Documentation/HOWTO:          http://userweb.kernel.org/~akpm/stuff/tpp.txt
./Documentation/HOWTO:      http://userweb.kernel.org/~akpm/stuff/tpp.txt
./Documentation/ja_JP/HOWTO:
http://userweb.kernel.org/~akpm/stuff/tpp.txt
./Documentation/ja_JP/HOWTO:      http://userweb.kernel.org/~akpm/stuff/tpp.txt
./Documentation/ja_JP/SubmittingPatches:http://userweb.kernel.org/~akpm/stuff/patch-scripts.tar.gz
./Documentation/ja_JP/SubmittingPatches:
<http://userweb.kernel.org/~akpm/stuff/tpp.txt>
./Documentation/SubmittingPatches:http://userweb.kernel.org/~akpm/stuff/patch-scripts.tar.gz
./Documentation/SubmittingPatches:
<http://userweb.kernel.org/~akpm/stuff/tpp.txt>
./Documentation/zh_CN/HOWTO:
http://userweb.kernel.org/~akpm/stuff/tpp.txt
./Documentation/zh_CN/HOWTO:     http://userweb.kernel.org/~akpm/stuff/tpp.txt
./Documentation/zh_CN/SubmittingPatches:http://userweb.kernel.org/~akpm/stuff/patch-scripts.tar.gz
./Documentation/zh_CN/SubmittingPatches:
<http://userweb.kernel.org/~akpm/stuff/tpp.txt>
./Documentation/ko_KR/HOWTO:
http://userweb.kernel.org/~akpm/stuff/tpp.txt
./Documentation/ko_KR/HOWTO:    http://userweb.kernel.org/~akpm/stuff/tpp.txt
./Documentation/development-process/2.Process:
http://userweb.kernel.org/~akpm/mmotm/

Please check and update them, thanks.
