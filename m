Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab1HLMsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 08:48:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48532 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab1HLMsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 08:48:39 -0400
Date: Fri, 22 Aug 2011 17:10:10 +0430
From: Ali Gholami Rudi <ali@rudi.ir>
To: Matthew Garrett <mjg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Keith Packard <keithp@keithp.com>,
        Michel Alexandre Salim <salimma@fedoraproject.org>,
        intel-gfx@lists.freedesktop.org, Richard Purdie <rpurdie@rpsys.net>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Sedat Dilek <sedat.dilek@googlemail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: missing acpi backlight bisected to 9661e92c10
Message-ID: <20112208171010@lilem.mirepesht>
In-Reply-To: <20110812121822.GA11301@srcf.ucam.org>
References: <4E428421.1000605@fedoraproject.org>
 <yunipq5gvxd.fsf@aiko.keithp.com>
 <20110810191700.81c3a7ee.akpm@linux-foundation.org>
 <20112108083014@lilem.mirepesht>
 <20112108160718@lilem.mirepesht>
 <20110811123929.GA22409@srcf.ucam.org>
 <20112108181410@lilem.mirepesht>
 <20110811141630.GA24704@srcf.ucam.org>
 <20112108185137@lilem.mirepesht>
 <20112208102524@lilem.mirepesht>
	<20110812121822.GA11301@srcf.ucam.org>
User-Agent: git://repo.or.cz/mailx.git
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg@redhat.com> wrote:
> 
> On Mon, Aug 22, 2011 at 10:25:24AM +0430, Ali Gholami Rudi wrote:
> 
> > Yet, /sys/devices/virtual/backlight/acpi_video0/brightness only
> > appears after the revert.  Seems something changes its behavior
> > if new_bd->dev.parent is not NULL in backlight_device_register().
> 
> Well, yes, if it has a parent it won't be under /sys/devices/virtual. 
> Does it appear under /sys/class/backlight ?

Yep!  Thought this is the 2.6.38-rc1 issue coming back (I really
thought I had searched /sys...).  Sorry for the noise.

Thanks,
Ali

