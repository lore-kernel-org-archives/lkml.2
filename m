Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab2GJUu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 16:50:57 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40677 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab2GJUuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 16:50:55 -0400
Message-ID: <4FFC95A6.6060203@gmail.com>
Date: Tue, 10 Jul 2012 22:50:46 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Joseph Salisbury <joseph.salisbury@canonical.com>
CC: Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] sound updates for 3.5-rc1
References: <s5hvcjn6ygk.wl%tiwai@suse.de> <4FFB7ED5.3080902@canonical.com>
In-Reply-To: <4FFB7ED5.3080902@canonical.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10.07.2012 03:01, Joseph Salisbury wrote:
> Some users are hitting a bug reported in bugzilla[0] and launchpad[1].
> The bug was introduced in v3.5-rc1, which is preventing some Logitech
> webcams from working.  I bisected down to the following commit as the
> cause of the regression:
> 
> edcd3633e72a1590c4cf46befe5e6cd03b5aec3e - ALSA: snd-usb: switch over to
> new endpoint streaming logic

Thanks for the reminder. I was able to reproduce this issue and prepare
a fix for it. Will post it on the ALSA list right now, as there's a
thread for that issue already.


Thanks,
Daniel
