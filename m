Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651Ab0K2TE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 14:04:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50737 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab0K2TE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 14:04:57 -0500
Message-ID: <4CF3F8EA.2010808@zytor.com>
Date: Mon, 29 Nov 2010 11:03:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pavel Machek <pavel@ucw.cz>, Kyle Moffett <kyle@moffetthome.net>,
        Marcus Meissner <meissner@suse.de>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, tj@kernel.org, akpm@osdl.org, w@1wt.eu,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
References: <20101116104600.GA24015@suse.de> <AANLkTi=F1vbwpOzyN9o0nuRtsEUTQx2j3==kLu9j7Ccb@mail.gmail.com> <20101118073126.GB32621@elte.hu> <20101123172437.GB8412@ucw.cz> <20101126073834.GC19589@elte.hu>
In-Reply-To: <20101126073834.GC19589@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2010 11:38 PM, Ingo Molnar wrote:
> 
> Yeah, restricting information is always a double edged sword - and by locking down 
> we are implicitly assuming that the number of people trying to do harm is larger 
> than the number of people trying to help. It is probably true though - and the 
> damage they can inflict is becoming more and more serious (financially, legally and 
> socially - and, in some cases, physically) with every year of humanity moving their 
> lives to the 'net.
> 
> So yes, the time has probably come to lock up "potentially harmful" information from 
> the default unprivileged user on Linux - at least from a default kernel policies 
> POV.
> 

The setting of these policies needs to be figured out sensibly.

One of my great complaints about several Linux distributions is that
they keep forcing log files to be readable only by root, even though
they do put the adm group in their default group file -- the adm group
is traditionally the group allowed to read log files.

It is a *good* thing for a *restricted set* of users to have *readonly*
access to this kind of information -- i.e., a group.  It is *not* a good
thing for system security or reliability to force the administrator to
assert root privileges to merely monitor information.

	-hpa
