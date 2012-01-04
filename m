Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab2ADASZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 19:18:25 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:41477 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042Ab2ADASX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 19:18:23 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1201041046330.18098@tundra.namei.org>
References: <43556.213.228.140.150.1323560920.squirrel@webmail.decimal.pt>
 <20111213180707.GI11747@quack.suse.cz> <!&!AAAAAAAAAAAYAAAAAAAAAKCACr8ZwetPrGXZsycJodKihAAAEAAAAGPJDX4w3wxIo8Onu2+q/xMBAAAAAA==@decimal.pt>
 <20120102115222.GA3626@quack.suse.cz> <20120103010826.GF3626@quack.suse.cz>
 <20120103123841.GA31457@quack.suse.cz> <1325604356.2095.23.camel@falcor>
 <CA+55aFzwq6XiAnX26uV+-mNsbGbnj0S=4nP5avPqKPw8OT+cmw@mail.gmail.com>
 <1325616312.2095.26.camel@falcor> <alpine.LRH.2.00.1201041046330.18098@tundra.namei.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 Jan 2012 16:18:01 -0800
X-Google-Sender-Auth: NJEXRCVn5-bagSvOEJAp8V96g0c
Message-ID: <CA+55aFxZ4_T8VRh6wAKC9-9PjsctrK1WnOmN-2EDNTeHA+OA4g@mail.gmail.com>
Subject: Re: Reiserfs.c bug in 3.2-rc5
To: James Morris <jmorris@namei.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
        haiyangz@microsoft.com, hjanssen@microsoft.com,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jorge Bastos <mysql.jorge@decimal.pt>, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <jlbec@evilplan.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 3, 2012 at 3:47 PM, James Morris <jmorris@namei.org> wrote:
>>
>> Just clarifying not all of commit fb88c2b, but only the
>> security_old_inode_init_security() hunk.
>
> Agreed.
>
> And yep, it's ugly :-\

Ok, applied - along with another last-minute fix - and pushed out.

Can everybody please test and double-check that what I applied was
what everybody agrees is the RightThing(tm)? I really wanted to do 3.2
today, but both of those commits are of the "please double-check"
kind, so..

                Linus
