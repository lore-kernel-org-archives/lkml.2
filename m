Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab2KBAYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 20:24:12 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:63689 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab2KBAYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 20:24:10 -0400
MIME-Version: 1.0
In-Reply-To: <20121102001429.GA2129@kroah.com>
References: <CAMBWrQ=Xrp-_opV0ej4rn20p3yTUP0TmYQHr5nG79szC0=WUDA@mail.gmail.com>
 <CAMBWrQm6CacSoUxZdNA9XPhDMqyAt2R15ZXxpCLEZcRvEeRiCg@mail.gmail.com> <20121102001429.GA2129@kroah.com>
From: Stan Hu <stanhu@gmail.com>
Date: Thu, 1 Nov 2012 17:23:48 -0700
Message-ID: <CAMBWrQmQqF7yjmZWkVFbjWrPUane-tB2sm6BCgn-x4QnXWYVgA@mail.gmail.com>
Subject: Re: help with diagnosing kernel oops in __mutex_lock_slowpath
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately, with this board I am using, it would be a significant
effort for me to get 3.6 or 3.7 running.  Do you have any suggestions
of what I should look for in the 3.2 kernel?

For now, I've worked around it by enabling the panic=10 and
panic_on_oops kernel=1 options to reboot when this happens.  The
system seems to come up fine after another try or two.

On Thu, Nov 1, 2012 at 5:14 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Nov 01, 2012 at 03:02:45PM -0700, Stan Hu wrote:
>> Hello,
>>
>> I'm getting this kernel oops sporadically with a custom Cortex-A8 ARM
>> board with a Linux 3.2.28 kernel.  The system is booting off an SD
>> card; interestingly this failure doesn't seem to happen when I boot
>> from NAND flash.   I would say 1 out 10 times it fails with a similar
>> backtrace.  Does anyone have any clue why this might be happening?
>
> Does this also happen on the 3.6 kernel, or 3.7-rc3?
>
> thanks,
>
> greg k-h
