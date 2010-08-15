Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab0HOPrc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 11:47:32 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40952 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758154Ab0HOPra convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 11:47:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=pVCvgI1MRJC9I60gDlQJdi8C1knKGCPMUBuHY5kes7rF6pt1s+qGUWEpnNRpz/By+T
         Nrhvod7Hydt74DXPAnUvAWCjOqO+8nog3sXY8sOf5TNNqdDS8Os/IqRZVQpE2DZiU8hm
         SA/Th1juXToqcD0dd2+yqh5PQjXj/yK/kW/M8=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sun, 15 Aug 2010 12:41:48 +0200
Message-ID: <AANLkTikV2eVo6KM5dSqfDwAwT=bVxnuWSpBE7F+JQU+_@mail.gmail.com>
Subject: Re: [git pull request] ACPI patches for 2.6.36.merge
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: len.brown@intel.com, Linux ACPI <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I pulled in release GIT-branch on top of 2.6.35-git16 (commit
5d7cb157025b3b4852f38e6e5e97d06ef12c1d78)

   $ git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
release

Unfortunately, the build breaks:

[ build.log ]
drivers/acpi/power.c: In function ‘acpi_power_off_device’:
drivers/acpi/power.c:252: error: ‘ref’ undeclared (first use in this function)
drivers/acpi/power.c:252: error: (Each undeclared identifier is
reported only once
drivers/acpi/power.c:252: error: for each function it appears in.)
make[5]: *** [drivers/acpi/power.o] Error 1
make[4]: *** [drivers/acpi] Error 2
make[3]: *** [drivers] Error 2


- Sedat -
