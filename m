Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760536Ab0HLUS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 16:18:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55942 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab0HLUS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 16:18:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=dr44p100mlc6mX6Gv61bFhn4QYrCq1fxPfseHNa9sOjFECsn8rbpOWnjQgdDy4AZoe
         hHdAH3yT6T6xSXguelkYd58DBvzM6Vud1M6RSTtW0v6q/stH6+Tnm32U64dwNZ4n6SZB
         XDfues/OBtlJvVmXtc9MVAdpDAbdVZv4KH/Vw=
Message-ID: <4C64571F.6000606@lwfinger.net>
Date: Thu, 12 Aug 2010 15:18:39 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>,
        John Stultz <johnstul@us.ibm.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Problem with commit deda2e81961e96be4f2c09328baca4710a2fd1a0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guys,

With the above commit, building an i386 version of the kernel results in the
following from the build:

kernel/built-in.o: In function `logarithmic_accumulation':
/home/finger/linux-realtek/kernel/time/timekeeping.c:715: undefined reference to
`__umoddi3'
/home/finger/linux-realtek/kernel/time/timekeeping.c:715: undefined reference to
`__udivdi3'
make: *** [.tmp_vmlinux1] Error 1

Reverting the patch allows the system to build correctly.

Larry
