Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab1GOQQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 12:16:22 -0400
Received: from mail.perches.com ([173.55.12.10]:4033 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab1GOQQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 12:16:21 -0400
Subject: Re: [PATCH 11/11] dynamic_debug: use a single printk() to emit msgs
From: Joe Perches <joe@perches.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jason Baron <jbaron@redhat.com>, gregkh@suse.de, jim.cromie@gmail.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAO+b5-qgrV=gfZAczxfPbGqVtv4ZD_zZHOn-BMVY9wnJytbrtw@mail.gmail.com>
References: <cover.1310657068.git.jbaron@redhat.com>
	 <3667c0a87dd8fd64fdf1b1e8107b130a9b41096e.1310657068.git.jbaron@redhat.com>
	 <CAO+b5-qA3s92YX2izXzvzt3MOrzRaPcZtDtK0cDte0ZXnRWxhA@mail.gmail.com>
	 <1310744914.7582.36.camel@Joe-Laptop>
	 <CAO+b5-p2B74+oVQRGcGxMp5ULZy8ZmF215Lz4qhbU=C4RnG8dw@mail.gmail.com>
	 <20110715160417.GB2493@redhat.com>
	 <CAO+b5-qgrV=gfZAczxfPbGqVtv4ZD_zZHOn-BMVY9wnJytbrtw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jul 2011 09:16:20 -0700
Message-ID: <1310746580.7582.50.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 18:10 +0200, Bart Van Assche wrote:
> On Fri, Jul 15, 2011 at 6:04 PM, Jason Baron <jbaron@redhat.com> wrote:
> > yes, but that approach uses 'KERN_CONT'. The point of patch 11/11 is to get rid
> > of KERN_CONT, which is racy.
> I know. What I'm trying to explain is that since patch 11/11 modifies
> dynamic_emit_prefix() such that it writes its output to a buffer there
> is no longer a need to write into that buffer with a single snprintf()
> call. Using multiple snprintf() calls is also fine. Hence it is
> possible to eliminate the two temporary arrays (tid[] and lineno[])
> from dynamic_emit_prefix() without reintroducing these races.

Ah, just so.  It's so easy to be narrow minded.

Jason, you are going to do this yes?

cheers, Joe

