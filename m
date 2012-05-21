Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab2EUUev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 16:34:51 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38414 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758308Ab2EUUet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 16:34:49 -0400
MIME-Version: 1.0
Date: Mon, 21 May 2012 22:34:48 +0200
Message-ID: <CAC9WiBiCW24QORG0037k0wRtkiffkNEHosu83Z64RwdWorGWjQ@mail.gmail.com>
Subject: 3.4: build failure for radio-rtrack driver
From: Francis Moreau <francis.moro@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I noticed a build failure when building 3.4:

  CC [M]  net/irda/irproc.o
drivers/media/radio/radio-rtrack2.c: In function 'rtrack2_alloc':
drivers/media/radio/radio-rtrack2.c:46:2: error: implicit declaration
of function 'kzalloc' [-Werror=implicit-function-declaration]
drivers/media/radio/radio-rtrack2.c:46:2: warning: return makes
pointer from integer without a cast [enabled by default]

which can be easily fixed, but wondering how it has been missed so far.

Thanks
-- 
Francis
