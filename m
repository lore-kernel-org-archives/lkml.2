Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab2E1HDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 03:03:46 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58877 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab2E1HDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 03:03:45 -0400
Message-ID: <4FC32330.8060300@monstr.eu>
Date: Mon, 28 May 2012 09:03:12 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze changes for 3.5-rc1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following changes.

Thanks,
Michal


The following changes since commit 76e10d158efb6d4516018846f60c2ab5501900bc:
   Linus Torvalds (1):
         Linux 3.4

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git next

Edgar E. Iglesias (2):
       microblaze: Add TLS support to sys_clone
       microblaze: Setup correct pointer to TLS area

Kautuk Consul (1):
       microblaze: Port OOM changes to do_page_fault

Lars-Peter Clausen (1):
       microblaze: Do not select GENERIC_GPIO by default

Michal Simek (1):
       microblaze: ftrace: Pass the first calling instruction for dynamic ftrace

  arch/microblaze/Kconfig          |    2 +-
  arch/microblaze/kernel/entry.S   |    7 ++++---
  arch/microblaze/kernel/mcount.S  |    2 +-
  arch/microblaze/kernel/process.c |    6 +++++-
  arch/microblaze/mm/fault.c       |   33 ++++++++++++++++++++++++++++-----
  5 files changed, 39 insertions(+), 11 deletions(-)


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
