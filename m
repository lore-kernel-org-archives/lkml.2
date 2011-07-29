Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab1G2UOg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 16:14:36 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57391 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752080Ab1G2UOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 16:14:35 -0400
X-Sasl-enc: mDhNAMl0KerDfcysOkPJMSfVr6H8xv6/3kQaS3LGD0Vh 1311970474
Date: Fri, 29 Jul 2011 15:14:33 -0500
From: Paul Jackson <pj@usa.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnaud Lacombe <lacombar@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        SergeySenozhatsky <sergey.senozhatsky@gmail.com>,
        DaveJones <davej@redhat.com>
Subject: Re: [06.5] Re: [GIT PULL] core/printk changes for v3.1
Message-Id: <20110729151433.b8b6a3d9.pj@usa.net>
In-Reply-To: <CA+55aFyqf6G2ZByfaTR5ZiKBVDMeiS2bC3r-WsSfc_M0bJViDg@mail.gmail.com>
References: <20110722125934.GA25433@elte.hu>
	<CACqU3MW-7_gCqNARdrPA5rZoZGLti+DMvkZsJN40VSDtU+VhpQ@mail.gmail.com>
	<1311679697.24752.28.camel@twins>
	<CACqU3MUghvskv4HrVn+w7rCTki0RkRwQfFUaaysHYOqB6V+q4A@mail.gmail.com>
	<CA+55aFyqf6G2ZByfaTR5ZiKBVDMeiS2bC3r-WsSfc_M0bJViDg@mail.gmail.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jul 2011 13:30:06 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Sadly, the gmail web interface cannot *send* patches without
> whitespace-mangling them. You have to send them as attachements, and
> there is no way to say "do this attachement inline".

I have updated my sendpatchset utility.  It works well with gmail's
SMTP server.  It could be used by those with a gmail account instead
of trying to send patches via their web interface.  Place one's
gmail account information in the $HOME/.sendpatchset.ini file, as
documented within the sendpatchset utility.

It requires Python.

You can find the latest sendpatchset at:

    http://pauljackson.us/sendpatchset.py
    http://pauljackson.us/COPYING

It's released under GPL license, and is an update of the same
sendpatchset that I published a few times back in 2004 - 2007,
while I worked at Silicon Graphics.  I am the same Paul Jackson
who worked on cpusets for a while, formerly known as pj AT sgi.com.

-- 
Paul Jackson <pj@usa.net>
