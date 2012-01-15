Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab2AOVYJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 16:24:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61634 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab2AOVYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 16:24:08 -0500
Message-ID: <4F1343F1.7090003@yahoo.co.uk>
Date: Sun, 15 Jan 2012 21:24:01 +0000
From: Sam Tygier <samtygier@yahoo.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111109 Thunderbird/3.1.16
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: panic in 3.2.x
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:b+r88+a6TLwoKiNh2jltiFba3hMDrAH4sGM+gm64CXc
 f5lCp+7ss+vexTerALcGFRk/wNQykZxP+J8LT4tRJKDxdiSEAm
 aTMT7VdErCAuRxTxQO4K8VlYqZrHz7nXI0CFoM2fadOGwFKrZF
 LBe8dfyXd6fpH3HAaVqOmirnvrHfDnUZoTvpG24wLXEYSvYK2p
 oMms8D0j95uxIQnN1XeCcUi7H2M1cCRinPfScN+uBxsOFSIZcG
 4jyLd3lTmDwvLCJalXU3zcFXG0LXvDl8+G7avWX6bp6h80mh3G
 NaD1+nJDbql0HB/kPtHFDZlPZ9/4mkLFsN02yD6OV8lRjgrvA=
 =
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have built a 3.2.0 kernel using the fedora kernel-3.2.0-2.fc17.src.rpm, and a 3.2.1 using kernel-3.2.1-4.fc17.src.rpm. With either of these I get several panics per day on a Lenovo S12 (intel version), but only if I have an SD card in the built in card reader. I am not really sure how to trigger them, but they are frequent enough that I could probably get more info if instructed.

I have not had any panics with 3.1.x kernels

The panics are all different, and I can't spot anything particular in common. Here is a bit of one:

EIP: [<c091de99>] __schedule+0x379/0x8b0 SS ESP: 0060:f400bea0
CR2: 000000000c043777a
Kernel panic - not syncing: Fatal exception in interupt
Pid: 0, comm: swapper/0 Tainted: G      D     3.2.0-2.fc16.i686 #1
Call Trace:
  [<c09174a6>] ? printk+0x2d/0x2f
  [<c0917371>] panic+0x5c/0x164
...

And some photos.
http://www.hep.manchester.ac.uk/u/sam/pub/32_panic/20120110_004.jpg
http://www.hep.manchester.ac.uk/u/sam/pub/32_panic/20120110_005.jpg
http://www.hep.manchester.ac.uk/u/sam/pub/32_panic/20120115_001.jpg

other info:
http://www.hep.manchester.ac.uk/u/sam/pub/32_panic/lshw.txt
http://www.hep.manchester.ac.uk/u/sam/pub/32_panic/dmesg.txt

I boot with nolapic_timer to avoid freezes.

Let me know if there is any other info I can give.

Sam
