Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab2AEHFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 02:05:17 -0500
Received: from zougloub.eu ([188.165.233.99]:42756 "EHLO zougloub.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab2AEHFO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 02:05:14 -0500
X-Greylist: delayed 607 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jan 2012 02:05:14 EST
Date: Thu, 5 Jan 2012 01:52:12 -0500
From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
To: Toralf =?UTF-8?B?RsO2cnN0ZXI=?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel crashed after unplugging an (encrypted) USB stick
Message-ID: <20120105015212.1d5045b2@zougloub.eu>
In-Reply-To: <201112271914.18564.toralf.foerster@gmx.de>
References: <201112271914.18564.toralf.foerster@gmx.de>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Dec 2011 19:14:18 +0100
Toralf Förster <toralf.foerster@gmx.de> wrote:

> 2011-12-27T19:03:56.681+01:00 n22 kernel: IP: [<c12172e5>] sd_revalidate_disk+0x25/0x1d70
> 2011-12-27T19:03:56.681+01:00 n22 kernel: *pde = 00000000 
> 2011-12-27T19:03:56.681+01:00 n22 kernel: Oops: 0000 [#1] SMP 

Recently I've been playing with SD cards on my netbook.
I had it today on 3.2-rc7, when removing/inserting one.

2011-10-08_20:30:30 [5681.629701] IP: [<ffffffff812cc3fe>] sd_revalidate_disk+0x26/0x159d
2011-12-22_15:06:07 [19094.131490] IP: [<ffffffff812cce54>] sd_revalidate_disk+0x26/0x1638

https://bugzilla.redhat.com/show_bug.cgi?id=750389
https://bugzilla.redhat.com/show_bug.cgi?id=754518
http://www.spinics.net/lists/linux-scsi/msg56270.html (Yet another hot unplug NULL pointer dereference (was Re: status of oops in sd_revalidate_disk?))

Apparently udisks-daemon triggers the bug, so it can be worked until proper fix.

-- 
cJ
