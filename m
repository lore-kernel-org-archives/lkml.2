Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab1IYUJs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 16:09:48 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49535 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418Ab1IYUJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 16:09:47 -0400
Date: Sun, 25 Sep 2011 22:09:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: Wizard <wizarddewhite@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: Seems the comment of find_next_system_ram() is not exact
Message-ID: <20110925200942.GA23489@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Wizard <wizarddewhite@gmail.com>, linux-kernel@vger.kernel.org,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
References: <CAOkaeLJTeewFWpHCVBqNwmuL7nEbFYnrQ86SQOO7fVg_Uc3Q4Q@mail.gmail.com>
 <20110925094222.GA11289@liondog.tnic>
 <CAOkaeLJHE-BVM+KOpB5hd0Jd_wyk0-XY=Qhzk+0j_U9opCbr-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOkaeLJHE-BVM+KOpB5hd0Jd_wyk0-XY=Qhzk+0j_U9opCbr-g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 25, 2011 at 11:02:47PM +0800, Wizard wrote:

Hi,

please do not top-post when replying to messages.

> Thanks for your reply and for your suggestion to use "git annotate".
> I learned a lot from you.
> 
> I see the commit by KAMEZAWA. While still not know why he change
> code this way to cover the overlap case.
> 
> I find the function is introduced in 2842f11419704f8707fffc82e10d2263427fc130.
> While the mm/memory_hotplug.c is chaged during this period.
> If I want to view the code at that moment, I should use git checkout
> 2842f11419704f8707fffc82e10d2263427fc130?

No need, you can simply do

git show 2842f11419704f8707fffc82e10d2263427fc130:kernel/resource.c

as with every other git commit and file tracked by git.

HTH.

-- 
Regards/Gruss,
    Boris.
