Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab0ITWaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 18:30:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40404
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753830Ab0ITWaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 18:30:04 -0400
Date: Mon, 20 Sep 2010 15:30:23 -0700 (PDT)
Message-Id: <20100920.153023.226756815.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
Subject: Re: [PATCH 09/10] jump label 11: add sparc64 support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1285021546.23122.698.camel@gandalf.stny.rr.com>
References: <cover.1284733808.git.jbaron@redhat.com>
	<3b5b071fcdb2afb7f67cacecfa78b14c740278a7.1284733808.git.jbaron@redhat.com>
	<1285021546.23122.698.camel@gandalf.stny.rr.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Mon, 20 Sep 2010 18:25:46 -0400

> 
> Jason, did you author this patch or did David?

I did.

Jason when you post patches other people have authored, you should
add a:

From: Mr. Author <email_of_author@foo.com>

to the top of your commit message.

This allows automated tools that pull patches into GIT to set
the author correctly when it is not you.

Thanks.
