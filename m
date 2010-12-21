Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab0LUVm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 16:42:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44183 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548Ab0LUVmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 16:42:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <nigel@tuxonice.net>
Subject: Re: Trying to find a TuxOnIce merging plan that works.
Date: Tue, 21 Dec 2010 22:41:44 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <4D111381.5000609@tuxonice.net>
In-Reply-To: <4D111381.5000609@tuxonice.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012212241.44442.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 21, 2010, Nigel Cunningham wrote:
> Hi Rafael.

Hi,

> As you may recall, I started working on a bunch of patches about six 
> months ago that have been very slow to get merged (yes, mostly my fault 
> for perhaps being overly careful about testing). Unfortunately, in the 
> process, you've merged other patches (the compression ones) that mean I 
> have to rewrite what I'd already done.
> 
> To avoid this happening again, I'm proposing that I only work on one 
> patch (or very small series of patches) at a time, and not start on the 
> next one until you've merged the previous into your for-Linus tree. I'll 
> keep an overall plan of where I intend to go, but take things very 
> slowly so I don't waste time like that again.
> 
> The downside is that means I won't always be able to show demonstrably 
> improvements immediately, but I guess we'll just have to cope with that 
> situation. I guess I can mitigate this downside by explaining where I'm 
> going, even if I can't provide numbers to prove it will be a real 
> improvement.
> 
> Does this sound feasible to you?

Yes, sounds reasonable.

Thanks,
Rafael
