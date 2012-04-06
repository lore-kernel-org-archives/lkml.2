Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab2DFIYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 04:24:50 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52069 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab2DFIYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 04:24:47 -0400
Message-ID: <4F7EA84C.7050700@suse.cz>
Date: Fri, 06 Apr 2012 10:24:44 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120404 Thunderbird/13.0a2
MIME-Version: 1.0
To: Xin Tong <xerox.time.tech@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: syscall descriptor table
References: <CALKntY2MONLeRvXs2xdamSAQeWDs4ERHjWuCxNL8_QRrHwVhqg@mail.gmail.com>
In-Reply-To: <CALKntY2MONLeRvXs2xdamSAQeWDs4ERHjWuCxNL8_QRrHwVhqg@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2012 11:55 PM, Xin Tong wrote:
> Can anyone please describe to me how x86 syscall works ( i.e. how it
> is dispatched to the correct function) on x86 ?
> 
> mov $1, %eax   ;; __NR_exit = 1
> mov $42, %ebx  ;; status = 42
> sysenter       ;; perform the syscall!
> 
> what does the sysenter instruction do ? what is the difference aganst int 0x80.

Please refer to some processor manual. For example: Intel 64 and IA-32
Architectures Software Developer’s Manual. For the entry point see
ia32_sysenter_target in arch/x86/kernel/entry_32.S for x86_32 or
arch/x86/ia32/ia32entry.S for x86_64 with 32-bit binary.

regards,
-- 
js
suse labs

