Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724Ab0EYOyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 10:54:12 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:49557 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758204Ab0EYOyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 10:54:11 -0400
From: Markus <M4rkusXXL@web.de>
To: linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle kernel paging request
Date: Tue, 25 May 2010 16:54:09 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.33.2-gentoo-r1-ck1; KDE/4.4.3; x86_64; ; )
Cc: Borislav Petkov <bp@amd64.org>
References: <201005231829.32106.M4rkusXXL@web.de> <201005251509.39495.M4rkusXXL@web.de> <20100525143120.GA18018@kryptos.osrc.amd.com>
In-Reply-To: <20100525143120.GA18018@kryptos.osrc.amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005251654.09288.M4rkusXXL@web.de>
X-Provags-ID: V01U2FsdGVkX19vvo1gsbLt5MqZCKSbgnU77n5OiEJbD5FxGZX4
	5kE4JGsTML6vjy2eEk0Y25KRgqpHT8v3CcFg6ObmMlYzM7Ed6v
	0wHfTSFzQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I already thought "swapper" to be unrelated to "swap", but who knows.

The linked article is pretty old, isnt it? I used mdadm to create the 
raid1 and "echo check > /sys/block/mdX/md/sync_action" to regulary start 
the check.

Its exactly the same kernel as before (the one crashing); Still the 
gentoo-kernel (vanilla+fbcondecor).

I will send a mail if anything happens.

Thanks for your time,
Markus

> From: Markus <M4rkusXXL@web.de>
> Date: Tue, May 25, 2010 at 03:09:39PM +0200
> 
> > Had disabled swap (saw the string "swapper" and "page_fault"...)
> > and now the problem does not show up anymore.
> 
> No, swapper is the idle task and I don't think it has anything to do
> with the oops - it simply happens to be the currently running process
> when the oops happens. And the kernel should be handling swapless
> configurations just fine for the cost of slowing down when RAM is
> depleted or OOM killing a memory hog.
> 
> > Dont know, if its now "fixed", but is it possible that raid1 and
> > swap on top does not really work? Normal system usage
> > (auto-detected raid1, add swap by fstab, regularly running a check
> > and perhaps a resync).
> 
> Enabling swap on raid1 might need a bit more work, see here:
> http://www.linuxjournal.com/article/5898
> 
> Anyways, let me know what happens and especially if it appears again.
> Now you say it doesn't happen anymore but le me ask: is this still
> the gentoo kernel or is it a vanilla one?
> 
> Thanks.

