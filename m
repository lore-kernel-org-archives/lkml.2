Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab2D3SRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 14:17:31 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39715 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab2D3SRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 14:17:31 -0400
MIME-Version: 1.0
Date: Mon, 30 Apr 2012 14:17:30 -0400
Message-ID: <CALyraeMbrFy6v-n=kFJBvxBNqB7eFVCPeBfjTNvg32rCBk8ynw@mail.gmail.com>
Subject: tty driver
From: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
To: kernelnewbies <Kernelnewbies@kernelnewbies.org>,
        Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

I am working on paging feature on tty, pty outputting. Is there anyway
I can do paging output at tty drivers by way of setting some options
using ioctl or ....
Please let me know, to give you some idea

if you type

ls -l | more on command prompt you see the output in paging fashion.
This is the kind of feature I want it on tty fds. Please let me know
if anyone has any better idea. thanks.


-- 
Regards,
Sri.
