Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934219Ab1J3QN4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 12:13:56 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52741 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933439Ab1J3QNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 12:13:55 -0400
MIME-Version: 1.0
X-Originating-IP: [109.84.197.238]
In-Reply-To: <CANvSZQ_h1QbSCWs2tBmOA9FXY=DTcgsom+WG9JJqm8-dm+aNyg@mail.gmail.com>
References: <CANvSZQ_h1QbSCWs2tBmOA9FXY=DTcgsom+WG9JJqm8-dm+aNyg@mail.gmail.com>
From: Thilo-Alexander Ginkel <thilo@ginkel.com>
Date: Sun, 30 Oct 2011 17:13:28 +0100
Message-ID: <CANvSZQ-9gAhxWbYKjh3M-Rb1=j8-rFrYKmwNjK6QaDLPGc8TXg@mail.gmail.com>
Subject: Re: Sporadic kernel panic on Lenovo T420s resume from S3
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

On Mon, Oct 10, 2011 at 21:08, Thilo-Alexander Ginkel <thilo@ginkel.com> wrote:
> recently, my Lenovo ThinkPad T420s has been sporadically crashing
> after waking up the machine from ACPI S3. The system locks up hard,
> i.e., MagicSysRq no longer works, but at least a dump is printed to
> the console. The process that is crashing is a kworker process, the
> topmost method on the call stack is "wq_worker_sleeping".
>
> The remaining call stack is available (as a photograph) at:
> https://secure.tgbyte.de/dropbox/ieNiema6.jpg
>
> Unfortunately, the top of the panic is not visible and scrolling back
> does not work.

The issue is still happening with a mainline 3.1 kernel (same dump as
above). Is there anyting I can do to capture more details? The machine
locks up completely, so MagicSysRq does not help when trying to
preserve the error log. Are there any mechanisms to persist some error
information when regular file systems are not available (RTC will
probably not suffice). Netconsole will be tricky to use as I am
typically on the road when using my laptop with no additional log sink
available.

Thanks,
Thilo
