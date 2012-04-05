Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab2DEVzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 17:55:45 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61388 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab2DEVzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 17:55:44 -0400
MIME-Version: 1.0
Date: Thu, 5 Apr 2012 17:55:43 -0400
Message-ID: <CALKntY2MONLeRvXs2xdamSAQeWDs4ERHjWuCxNL8_QRrHwVhqg@mail.gmail.com>
Subject: syscall descriptor table
From: Xin Tong <xerox.time.tech@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can anyone please describe to me how x86 syscall works ( i.e. how it
is dispatched to the correct function) on x86 ?

mov $1, %eax   ;; __NR_exit = 1
mov $42, %ebx  ;; status = 42
sysenter       ;; perform the syscall!

what does the sysenter instruction do ? what is the difference aganst int 0x80.

Thanks

Xin
