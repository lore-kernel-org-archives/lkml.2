Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751182Ab0KBI1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 04:27:06 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36996 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab0KBI1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 04:27:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:content-type;
        b=dsVD10+SspiMNnptFDs2MLo5JoxvOOvX3Bd8Zfb6KxlG58ehaK4LRUvLB9kfaz0fHa
         1S25M8gTUXolbEYJDf+L0w6nRVEY+vmc69o00XJDKHgev3eIs1HYyiaTxlBO3azpLINw
         SqbQgRTtrmkHRob/P9a7kiCH6ttY2kXXjDXCU=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
Date: Tue, 2 Nov 2010 08:26:59 +0000
Message-ID: <AANLkTik=04z2thHBS3Z9n68QnTs=i8g8qTFtNT3jb8cg@mail.gmail.com>
Subject: Pure kernel '2.6.37-rc1-00001-ge99d11d' shown as ~-dirty after compilation
From: trapDoor <trapdoor6@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

,Hello,
When I run 'make kernelrelease' on freshly cloned Linus' git tree it
shows kernel version as: '2.6.37-rc1-00001-ge99d11d' - and that's
correct.
But after compilation it turned up '2.6.37-rc1-00001-ge99d11d-dirty'.

I didn't apply any custom patches to my local tree between 'make
kernelrelease' and compilation. What I only added - and before running
'make kernelrelease' - were the following Radeon firmware blobs for my
graphic card, which I placed in <kernel-source>/firmware/radeon/, in
order to compile them in:
REDWOOD_me.bin
REDWOOD_pfp.bin
REDWOOD_rlc.bin

That's how I always did and none of the git-kernels I compiled before
was referred to as '-dirty' due to the firmware blobs added manually.
Also, the kernel version shown by 'make kernelrelease' never differed
from the final kernel version after compilation. Of course assuming
that no patches were applied in the meantime and no extra string was
appended manually to the kernel version.

So, what's this '-dirty' about?

-- 
Thanks,
Tomasz
