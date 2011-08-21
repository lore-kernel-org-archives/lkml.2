Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab1HKO1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:27:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58805 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab1HKO1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 10:27:21 -0400
Date: Thu, 21 Aug 2011 18:51:37 +0430
From: Ali Gholami Rudi <ali@rudi.ir>
To: Matthew Garrett <mjg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Keith Packard <keithp@keithp.com>,
        Michel Alexandre Salim <salimma@fedoraproject.org>,
        intel-gfx@lists.freedesktop.org, Ali Gholami Rudi <aliqrudi@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Sedat Dilek <sedat.dilek@googlemail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: missing acpi backlight bisected to 9661e92c10
Message-ID: <20112108185137@lilem.mirepesht>
In-Reply-To: <20110811141630.GA24704@srcf.ucam.org>
References: <yunliv38ugd.fsf@aiko.keithp.com>
 <20110808213140.GA32504@srcf.ucam.org>
 <yunfwlb8qy4.fsf@aiko.keithp.com>
 <4E428421.1000605@fedoraproject.org>
 <yunipq5gvxd.fsf@aiko.keithp.com>
 <20110810191700.81c3a7ee.akpm@linux-foundation.org>
 <20112108083014@lilem.mirepesht>
 <20112108160718@lilem.mirepesht>
 <20110811123929.GA22409@srcf.ucam.org>
 <20112108181410@lilem.mirepesht>
	<20110811141630.GA24704@srcf.ucam.org>
User-Agent: git://repo.or.cz/mailx.git
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg@redhat.com> wrote:
> Well, that all looks fine. And I also can't see any way that this commit
> could cause the backlight not to appear - all it does is set the parent 
> if it's present. There's no new path that could cause it to return 
> early. Does reverting this patch really make things work?

Yes.  I'm running the patched kernel right now.

I can apply a debug patch on the unchanged kernel, if it helps?

	Ali

