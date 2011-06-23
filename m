Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219Ab1FWKKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 06:10:30 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:51537 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759170Ab1FWKK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 06:10:29 -0400
Date: Thu, 23 Jun 2011 11:10:01 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Andres More <more.andres@gmail.com>,
        Daniel Kenji Toyama <kenji.toyama@gmail.com>,
        Jim Lieb <lieb@canonical.com>,
        Forest Bond <forest@alittletooquiet.net>
Subject: Excessive frame size
Message-ID: <20110623101001.GA14199@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a MIPS allyesconfig build I got the following warning:

  CC [M]  drivers/staging/vt6656/int.o
drivers/staging/vt6656/iwctl.c: In function ‘iwctl_giwaplist’:
drivers/staging/vt6656/iwctl.c:787:1: warning: the frame size of 1288 bytes is larger than 1024 bytes [-Wframe-larger-than=]

That's a huge stackpig already on a 32-bit kernel and it will only be bigger
on a 64-bit kernel!

  Ralf
