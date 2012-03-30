Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935058Ab2C3Wuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:50:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51821 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934129Ab2C3Wup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 18:50:45 -0400
Message-ID: <4F7638C3.4060301@samsung.com>
Date: Fri, 30 Mar 2012 15:50:43 -0700
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: viro@zeniv.linux.org.uk,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: error: 'SEGMENT_SIZE' undeclared with arm-eabi-gcc toolchain
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Occurs following error with arm-eabi-gcc toolchain (gcc version 4.4.3 -
GCC). But there is no error with arm-none-linux-gnueabi-gcc toolchain
(gcc version 4.4.1 - Sourcery G++ Lite 2009q3)...

fs/binfmt_aout.c: In function 'load_aout_binary':
fs/binfmt_aout.c:255: error: 'SEGMENT_SIZE' undeclared (first use in
this function)
fs/binfmt_aout.c:255: error: (Each undeclared identifier is reported
only once
fs/binfmt_aout.c:255: error: for each function it appears in.)
make[2]: *** [fs/binfmt_aout.o] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [fs] Error 2

Any idea?

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.
