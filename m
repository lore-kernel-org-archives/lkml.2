Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab0EZRL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 13:11:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52864 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab0EZRL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 13:11:56 -0400
X-Authority-Analysis: v=1.1 cv=WC2cwRI/KXdLNEmE8ivg2cmI8vFt6dWmaZdvaJ93QHU= c=1 sm=0 a=Fogt7QVrsnkA:10 a=yQWWgrYGNuUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=ZW4iH3G3atxXlYsZSAYA:9 a=MaCzacFuu3luLZcbTHDRWFWKtjYA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] asm-generic: Use raw_local_irq_save/restore instead
 local_irq_save/restore
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org, michal.simek@petalogix.com,
       arnd@arndb.de, john.williams@petalogix.com, tglx@linutronix.de,
       peter.fritzsche@gmx.de, anton@samba.org, mingo@elte.hu
In-Reply-To: <20100526100805.171b3c48.akpm@linux-foundation.org>
References: <1274863724-14906-1-git-send-email-monstr@monstr.eu>
	 <1274863724-14906-2-git-send-email-monstr@monstr.eu>
	 <1274884963.22648.245.camel@gandalf.stny.rr.com>
	 <20100526100805.171b3c48.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 26 May 2010 13:11:51 -0400
Message-ID: <1274893911.22648.246.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-26 at 10:08 -0700, Andrew Morton wrote:

> 
> If a developer looks at atomic_add_return() and asks himself "why did
> this use raw_local_irq_save()", the only way of answering that question
> is to go groveling through the git logs, which is a right PITA if
> you're trying to get some coding work done.
> 
> Guys, any time you add code which is non-obvious at the raw C level, it
> *needs* a comment!

Totally agree!  I've gotten pretty good at adding comments to changes
like this that I do. I need to get better at telling others to comment
their work ;-)

-- Steve



