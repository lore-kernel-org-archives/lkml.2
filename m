Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab2L1BE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 20:04:26 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:39219 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab2L1BEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 20:04:24 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Fri, 28 Dec 2012 02:04:23 +0100
Message-ID: <CA+icZUVRrAcNy2_JsYAS5Ff=c6tthHHB=rj3eHPFcwUh5APiug@mail.gmail.com>
Subject: Re: Linux 3.8-rc1 (mei driver BROKEN)
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, khoroshilov@ispras.ru
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I am not sure if Greg is on holidays as his char-misc GIT tree didn't
get updated the last days.

The MEI driver causes here a serious regression requiring a hard cold
start of the machine I am working on.
A fix "mei: fix mismatch in mutex unlock-lock in mei_amthif_read()"
was already sent to LKML [1] and fixes the issue for me.

Can you push that a bit?
Feel free to add any credits.

Regards,
- Sedat -

[1] https://patchwork.kernel.org/patch/1904801/
