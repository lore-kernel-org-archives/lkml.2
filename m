Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab1IDOZy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 10:25:54 -0400
Received: from mail.ss.pku.edu.cn ([211.101.48.138]:53485 "EHLO
	mail.ss.pku.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab1IDOZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 10:25:50 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1109040945370.9175-100000@netrider.rowland.org>
References: <CAF1ivSbuRiY6Q75LUTGV6tN=KrKfVYjTV3=rZ51EiZY==707Uw@mail.gmail.com>
	<Pine.LNX.4.44L0.1109040945370.9175-100000@netrider.rowland.org>
Date: Sun, 4 Sep 2011 22:25:40 +0800
Message-ID: <CAF1ivSaFt9ZBsM4s7NyjJWz6QBE7xcS21bXGADp4NPp=2XcYEA@mail.gmail.com>
Subject: Re: [BUG] D state process after unplug and umount usb disk
From: Lin Ming <mlin@ss.pku.edu.cn>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dave Young <hidave.darkstar@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, fengguang.wu@intel.com,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 4, 2011 at 9:49 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>
>> Where does this exit signal come from?
>> Does USB interrupt handler will send kill signal to all processes
>> accessing it when it's unplugged(by hand)?
>
> The USB stack does not send any signals at all unless a process
> specifically asks for them.

How to ask?

I have not checked, but think umount code path will not send signal to process.
Curiously, where does the exit signal come from?

Dave,
Did you press "Ctrl + C" on cat?

Lin Ming
