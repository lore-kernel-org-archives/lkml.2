Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab3ACPM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 10:12:26 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:45156 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab3ACPMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 10:12:24 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Thu, 3 Jan 2013 16:12:23 +0100
Message-ID: <CA+icZUV-rgfmNRK+RAGRywRhzyV4-z+s4yB0+xW4WHUjScdjyg@mail.gmail.com>
Subject: Re: 3.8-rc2: EFI framebuffer lock inversion...
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Alan Cox <alan@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fbdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have tested the fb-fix [1] from Alan on top of Linux v3.8-rc2.

Unfortunately, several people still complain about it.
As Boris shouted out... Apply directly to mainline?

Feel free to add a "Tested-by".

Just FYI: There seems to exist a locking problem with efifb reported
by Daniel J (also see [1]).

Regards,
- Sedat -

[1] http://marc.info/?t=135721787600001&r=1&w=2
[2] https://patchwork.kernel.org/patch/1757061/
