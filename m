Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab2LBCIu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 21:08:50 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:38938 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab2LBCIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 21:08:48 -0500
MIME-Version: 1.0
In-Reply-To: <87r4n9u6nk.wl%satoru.takeuchi@gmail.com>
References: <20121130185118.302752929@linuxfoundation.org>
	<87r4n9u6nk.wl%satoru.takeuchi@gmail.com>
Date: Sat, 1 Dec 2012 19:08:48 -0700
Message-ID: <CAKocOOOcuYt=45d1d0+W2mH+MiNPf=6ic2jAmcqFSEqx72E1JA@mail.gmail.com>
Subject: Re: [ 00/56] 3.4.21-stable review
From: Shuah Khan <shuahkhan@gmail.com>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 1, 2012 at 8:35 AM, Satoru Takeuchi
<satoru.takeuchi@gmail.com> wrote:
> At Fri, 30 Nov 2012 10:54:52 -0800,
> Greg Kroah-Hartman wrote:
>>
>> This is the start of the stable review cycle for the 3.4.21 release.
>> There are 56 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sun Dec  2 18:50:02 UTC 2012.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>       kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.21-rc1.gz
>> and the diffstat can be found below.
>
> 3.4.21-rc1 can be built and boot without any problem. Building a kernel with
> this kernel also works fine.
>

Patch applied cleanly, compiled and booted on the following systems:
HP EliteBook 6930p Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics

-- Shuah
