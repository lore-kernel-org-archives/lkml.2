Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab2LOOYL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 09:24:11 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46459 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab2LOOYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 09:24:08 -0500
MIME-Version: 1.0
In-Reply-To: <20121214222252.781413287@linuxfoundation.org>
References: <20121214222252.781413287@linuxfoundation.org>
Date: Sat, 15 Dec 2012 07:24:08 -0700
Message-ID: <CAKocOON75_eyNYUmbsgHK6NaaeJP3jA6K10gvBYCwU4veu3KPQ@mail.gmail.com>
Subject: Re: [ 00/37] 3.6.11-stable review
From: Shuah Khan <shuahkhan@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 4:00 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> Note: This is going to be the last 3.6.y kernel release, unless
> something major comes up, everyone should be moving to the 3.7.y kernel
> at this point in time.
>
> This is the start of the stable review cycle for the 3.6.11 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Dec 16 22:16:49 UTC 2012.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.6.11-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Patches applied cleanly to 3.0.y, 3.4.y, 3.6.y, and 3.7.y.
Compiled and booted on the following systems:
HP EliteBook 6930p Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics

I started cross-compile tests and will report the status.

-- Shuah
