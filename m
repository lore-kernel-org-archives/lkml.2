Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab1DEPPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:15:42 -0400
Received: from ftp.sofha.de ([82.144.60.99]:42745 "EHLO ftp.sofha.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053Ab1DEPPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:15:41 -0400
Message-ID: <4D9B321B.9050805@snafu.de>
Date: Tue, 05 Apr 2011 17:15:39 +0200
From: Oncaphillis <oncaphillis@snafu.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Segher Boessenkool <segher@kernel.crashing.org>
CC: Xiaofan Chen <xiaofanc@gmail.com>, libusb-devel@lists.sourceforge.net,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Libusb-devel] Kernel bug message and missing data      on	libusb_interrupt_transfer
References: <4D99B60D.3030009@snafu.de>    <BANLkTi=mU=v_6gH_5VCwZZmiX+UoqAVf+w@mail.gmail.com>    <4D99C83A.2080807@snafu.de> <4D9AE10E.3080501@snafu.de> <56341.94.211.195.167.1302015286.squirrel@gate.crashing.org>
In-Reply-To: <56341.94.211.195.167.1302015286.squirrel@gate.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2011 04:54 PM, Segher Boessenkool wrote:
>>> I'm in an environment where we are
>>> reluctant to switch between versions. I had a hard time to
>> Pid: 14293, comm: E25Stress Tainted: G      D    2.6.30.10 #2 To Be
>> Filled By O.E.M.
>> RIP: 0010:[<ffffffff8028d2f8>]  [<ffffffff8028d2f8>] kfree+0x7c/0xdb
>> Suprisingly now the kernel is reported as tainted although there isn't
>> any module inserted the
> That is not true; "G" means you have loaded a (GPL-compatible) module.
> "D" means the kernel died.  It died because it tried to dealloc memory
> using a bad pointer, perhaps a null pointer.
>
> Your kernel is two years old, you should try a current kernel.
>
>

Thanks -- Didn't know anything about the 'G D' convention. Although
/proc/modules is empty (I don't have lsmod on the target system).

  We already have tried 2.6.36.x coming up with the same error.
Alan Stern recommended testing 2.6.3(8|9-rc1) which I'm currently doing.

O.

> Segher
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

