Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab0ETRNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 13:13:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43024 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502Ab0ETRNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 13:13:08 -0400
Date: Thu, 20 May 2010 19:13:06 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Don Prince <dhprince-devel@yahoo.co.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT] HID
In-Reply-To: <alpine.LFD.2.00.1005200948210.23538@i5.linux-foundation.org>
Message-ID: <alpine.LNX.2.00.1005201905320.28092@pobox.suse.cz>
References: <alpine.LNX.2.00.1005191430370.28092@pobox.suse.cz> <alpine.LFD.2.00.1005200912540.23538@i5.linux-foundation.org> <alpine.LFD.2.00.1005200922020.23538@i5.linux-foundation.org> <alpine.LNX.2.00.1005201834190.28092@pobox.suse.cz>
 <alpine.LFD.2.00.1005200948210.23538@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 May 2010, Linus Torvalds wrote:

> Well, I look at something like "hid-ortec.c", and it has basically a few 
> lines of code, much of it __init, and I say "ok, that makes sense to not 
> even ask about".
> 
> So I can see your argument. That said, I've never even _heard_ of ortek. 
> Maybe it's some common chip and I use it every day. But even for something 
> that small, I'd wonder how common they really are.
> 
> So that kensington driver is a good example of something where I do think 
> it makes sense to make it default. It's small, and kensington is a big 
> name.
> 
> But when the driver is several hundred lines, and the text size is 
> probably in the kilobytes (I didn't compile that new driver, but even the 
> trivial ones are a few hundred bytes) _and_ the driver is for something 
> I've never even heard about, then I really think it shouldn't be enabled 
> without asking.

Well the borderline is still a little bit vague, but I see your point.

Having the things we used to support even before the quirk splitup 
compiled without asking, and separating the rest of the drivers into 
'really really really small and trivial, or common enough' and 'the rest' 
makes sense. 
And explicitly asking for 'the rest'.

This would basically mean removing the 'EMBEDDED' crap from a few drivers 
in Kconfig. Do you want me to fix that now and redo the pull request, or 
are you going to pull it anyway and I will rearrange that in 2nd merge 
round later?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
