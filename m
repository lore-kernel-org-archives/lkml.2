Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130Ab2IFBB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 21:01:57 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:57381 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760096Ab2IFBBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 21:01:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120905234220.GA30393@kroah.com>
References: <1344929718-22736-1-git-send-email-tmshlvck@gmail.com>
	<1346887016-10415-1-git-send-email-tmshlvck@gmail.com>
	<20120905234220.GA30393@kroah.com>
Date: Thu, 6 Sep 2012 03:01:54 +0200
Message-ID: <CAEB7QLD2wbdoDFOzRbL39ZPVVtyf5ZYSqz0Y3TTZx3sKQKat-w@mail.gmail.com>
Subject: Re: [PATCHv5 1/1] uartclk value from serial_core exposed to sysfs
From: Tomas Hlavacek <tmshlvck@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, marek.vasut@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

On Thu, Sep 6, 2012 at 1:42 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Sep 06, 2012 at 01:16:56AM +0200, Tomas Hlavacek wrote:
>> Added file /sys/devices/.../tty/ttySX/uartclk to allow reading
>> uartclk value in struct uart_port in serial_core via sysfs.
>>
>> tty_register_device() has been generalized and refactored in order
>> to add support for setting drvdata and attribute_group to the device.
>>
>> Signed-off-by: Tomas Hlavacek <tmshlvck@gmail.com>
>> ---
>>  Documentation/ABI/testing/sysfs-tty |    9 ++++++
>>  drivers/tty/serial/serial_core.c    |   36 ++++++++++++++++++++-
>>  drivers/tty/tty_io.c                |   59 +++++++++++++++++++++++++++++++++--
>>  include/linux/tty.h                 |    4 +++
>>  4 files changed, 104 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-tty b/Documentation/ABI/testing/sysfs-tty
>> index b138b66..2f10855 100644
>
> Odd, what tree did you make this against?  It doesn't apply at all, even
> if I mess with it to try a --3way merge, it still throws up a ton of
> conflicts.
>
> Care to do it against my tty-next branch in git?

I did it wrong obviously. Sorry. I am resending it (it is going to be
against tty-next branch in
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git, I hope
it is right this time).

Tomas
