Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab2ADBFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 20:05:11 -0500
Received: from tundra.namei.org ([65.99.196.166]:59323 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922Ab2ADBFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 20:05:07 -0500
Date: Wed, 4 Jan 2012 12:02:36 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
        haiyangz@microsoft.com, hjanssen@microsoft.com,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jorge Bastos <mysql.jorge@decimal.pt>, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <jlbec@evilplan.org>
Subject: Re: Reiserfs.c bug in 3.2-rc5
In-Reply-To: <CA+55aFxZ4_T8VRh6wAKC9-9PjsctrK1WnOmN-2EDNTeHA+OA4g@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1201041200450.18323@tundra.namei.org>
References: <43556.213.228.140.150.1323560920.squirrel@webmail.decimal.pt> <20111213180707.GI11747@quack.suse.cz> <!&!AAAAAAAAAAAYAAAAAAAAAKCACr8ZwetPrGXZsycJodKihAAAEAAAAGPJDX4w3wxIo8Onu2+q/xMBAAAAAA==@decimal.pt> <20120102115222.GA3626@quack.suse.cz>
 <20120103010826.GF3626@quack.suse.cz> <20120103123841.GA31457@quack.suse.cz> <1325604356.2095.23.camel@falcor> <CA+55aFzwq6XiAnX26uV+-mNsbGbnj0S=4nP5avPqKPw8OT+cmw@mail.gmail.com> <1325616312.2095.26.camel@falcor> <alpine.LRH.2.00.1201041046330.18098@tundra.namei.org>
 <CA+55aFxZ4_T8VRh6wAKC9-9PjsctrK1WnOmN-2EDNTeHA+OA4g@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jan 2012, Linus Torvalds wrote:

> Can everybody please test and double-check that what I applied was
> what everybody agrees is the RightThing(tm)? I really wanted to do 3.2
> today, but both of those commits are of the "please double-check"
> kind, so..

Boots up ok for me, although I'm not using reiserfs or ocfs2.  The patch 
looks correct.


Thanks.



- James
-- 
James Morris
<jmorris@namei.org>
