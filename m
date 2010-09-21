Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab0IUOlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 10:41:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44970 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853Ab0IUOlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 10:41:20 -0400
Message-ID: <0e1f6b339e72a449fed0df7b801da607.squirrel@www.firstfloor.org>
In-Reply-To: <20100921143555.GA2873@redhat.com>
References: <cover.1284733808.git.jbaron@redhat.com>
    <ee8b3595967989fdaf84e698dc7447d315ce972a.1284733808.git.jbaron@redhat.com>
    <20100921131232.GA3024@one.firstfloor.org>
    <20100921143555.GA2873@redhat.com>
Date: Tue, 21 Sep 2010 16:41:19 +0200
Subject: Re: [PATCH 03/10] jump label v11: base patch
From: "Andi Kleen" <andi@firstfloor.org>
To: "Jason Baron" <jbaron@redhat.com>
Cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        tglx@linutronix.de, rostedt@goodmis.org, roland@redhat.com,
        rth@redhat.com, mhiramat@redhat.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, vgoyal@redhat.com,
        sam@ravnborg.org, tony@bakeyournoodle.com
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> So there are ~150 tracepoints, but this code is also being proposed for
> use with 'dynamic debug' of which there are > 1000, and I'm hoping for
> more users moving forward.

Even 1000 is fine to walk, but if it was sorted a binary search
would be much faster anyways. That is then you would still
need to search for each module, but that is a relatively small
number (< 100)

> Also, I think the hash table deals nicely with modules.

Maybe but it's also a lot of code. And it seems to me
that it is optimizing the wrong thing. Simpler is nicer.

-Andi

