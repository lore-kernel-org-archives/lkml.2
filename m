Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab1CYVYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 17:24:52 -0400
Received: from trent.utfs.org ([194.246.123.103]:44857 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092Ab1CYVYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 17:24:51 -0400
Date: Fri, 25 Mar 2011 14:24:48 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Daniel Reichelt <debian@nachtgeist.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: procfs: boot- and runtime configurable access mode for /proc/<pid>
 dirs
In-Reply-To: <20110324203758.GF22723@ZenIV.linux.org.uk>
Message-ID: <alpine.DEB.2.01.1103251418300.4945@trent.utfs.org>
References: <4D8AC408.9000503@nachtgeist.net> <20110324073225.GA3806@p183.telecom.by> <4D8B03D6.2090204@nachtgeist.net> <20110324182230.GB5187@p183.telecom.by> <4D8B991E.5070604@nachtgeist.net> <20110324203758.GF22723@ZenIV.linux.org.uk>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Not sure If I understand correctly, but:

On Thu, 24 Mar 2011 at 20:37, Al Viro wrote:
> Bull.  /proc/<pid>/foo contents is sensitive, your patch doesn't do
> you any good.  fork(), open /proc/<child's PID>/foo in parent, then
> exec suid-root binary in child.

...you would have to roll your own suid-root binary to be able to look 
into other /proc/PID directories, no? But making a binary suid-root 
requires root to begin with.

I'd love to finally have a more restrictive /proc directory. Even if it 
only makes things "harder" (not necessarily "impossible") to get 
information from user users on the same box.

Christian.
-- 
BOFH excuse #216:

What office are you in? Oh, that one.  Did you know that your building was built over the universities first nuclear research site? And wow, aren't you the lucky one, your office is right over where the core is buried!
