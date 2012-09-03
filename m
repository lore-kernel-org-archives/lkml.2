Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab2ICPdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 11:33:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46487 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260Ab2ICPdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 11:33:05 -0400
Message-ID: <5044CDAB.4000902@gmail.com>
Date: Mon, 03 Sep 2012 23:32:59 +0800
From: daley <daleydeng@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Two question about kernel global function declaration and directory
 layout
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, everyone, I'm a big fan of the kernel, I was always being attracted 
by its clean and intelligent design. I'm new to the mailing list and 
this is my first post. I want to ask two basic question about kernel 
which bother me a lot, I've googled a lot but nobody could give a 
suitable answer .

The first one is about global function declaration, I was confused about 
the usage of keyword "extern" before a global function which declared in 
the header file. for example,

<include/linux/kernel.h>
extern long (*panic_blink)(int state);
__printf(1, 2)
void panic(const char *fmt, ...)
         __noreturn __cold;
extern void oops_enter(void);
extern void oops_exit(void);
void print_oops_end_marker(void);
extern int oops_may_print(void);
void do_exit(long error_code)
         __noreturn;
void complete_and_exit(struct completion *, long)
         __noreturn;

the same thing also appeared on other header files a lot. To my 
knowledge, there's no difference between whether has the "extern" before 
global function, is this due to the legacy problem or have other meaning?

The second question is why not move the *sound* directory into the 
*drivers* directory or put bigger subsystem out of drivers, since there 
are more bigger subsystems(e.g. media, scsi) than sound?

Can anybody help?
Thanks.

-- 
daleydeng
Beijing, China

