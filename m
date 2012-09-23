Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab2IWUe0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 16:34:26 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61887 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab2IWUeZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 16:34:25 -0400
MIME-Version: 1.0
Date: Sun, 23 Sep 2012 16:34:24 -0400
Message-ID: <CAEMuUziMGAM4UOeOGWwG9jiceU9K7NSzqbryMxHwFDfmOfqQdA@mail.gmail.com>
Subject: arch/x86/lib/inat.c Error
From: Franklin Wei <frankhwei536@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Something wrong with lines 29-86
Error message when compiling:
  CC      arch/x86/lib/inat.o
arch/x86/lib/inat.c: In function ‘inat_get_opcode_attribute’:
arch/x86/lib/inat.c:29: error: ‘inat_primary_table’ undeclared (first
use in this function)
arch/x86/lib/inat.c:29: error: (Each undeclared identifier is reported only once
arch/x86/lib/inat.c:29: error: for each function it appears in.)
arch/x86/lib/inat.c: In function ‘inat_get_escape_attribute’:
arch/x86/lib/inat.c:48: error: ‘inat_escape_tables’ undeclared (first
use in this function)
arch/x86/lib/inat.c: In function ‘inat_get_group_attribute’:
arch/x86/lib/inat.c:67: error: ‘inat_group_tables’ undeclared (first
use in this function)
arch/x86/lib/inat.c: In function ‘inat_get_avx_attribute’:
arch/x86/lib/inat.c:86: error: ‘inat_avx_tables’ undeclared (first use
in this function)
make[1]: *** [arch/x86/lib/inat.o] Error 1
make: *** [arch/x86/lib] Error 2
Kernel version is 3.6 rc6
Compiling on Debian Squeeze running on Macbook
Thanks in advance!
