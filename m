Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761443Ab0HMKNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 06:13:35 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60965 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab0HMKNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 06:13:34 -0400
Message-ID: <4C651AC9.6040901@monstr.eu>
Date: Fri, 13 Aug 2010 12:13:29 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>, Mike Frysinger <vapier@gentoo.org>,
        Greg Ungerer <gerg@uclinux.org>
Subject: 12fdff3fc2483f906ae6404a6e8dcf2550310b6f - Add a dummy printk function
 for the maintenance of unused printks
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

you forget to remove no_printk() from mm/nommu.c in subject commit.

I expect that same problen on all noMMU platforms.


Error message:
mm/nommu.c:41: error: conflicting types for 'no_printk'
include/linux/kernel.h:314: error: previous definition of 'no_printk' 
was here
mm/nommu.c: In function 'do_munmap':
mm/nommu.c:1576: warning: format '%zx' expects type 'size_t', but 
argument 4 has type 'unsigned int'
make[1]: *** [mm/nommu.o] Error 1
make: *** [mm] Error 2

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
