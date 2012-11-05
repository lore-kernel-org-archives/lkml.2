Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab2KEDYW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 22:24:22 -0500
Received: from ozlabs.org ([203.10.76.45]:45504 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501Ab2KEDYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 22:24:19 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Josh Boyer <jwboyer@redhat.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] MODSIGN: Add modules_sign make target
In-Reply-To: <20121102124834.GQ6627@hansolo.jdub.homelinux.org>
References: <20121031135605.GJ6627@hansolo.jdub.homelinux.org> <87zk314w1t.fsf@rustcorp.com.au> <20121101112535.GL6627@hansolo.jdub.homelinux.org> <87ip9o4rpp.fsf@rustcorp.com.au> <20121102124834.GQ6627@hansolo.jdub.homelinux.org>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 05 Nov 2012 12:41:16 +1030
Message-ID: <87sj8oyf23.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Boyer <jwboyer@redhat.com> writes:
> On Fri, Nov 02, 2012 at 01:49:14PM +1030, Rusty Russell wrote:
>> My comment was more that this relies on eu-strip, because we always
>> sign modules on installation, so you need eu-strip to *unsign* them
>> (strip won't do it, BTW).
>
> Really?  Which version of binutils are you using?  The strip I have here
> seems to have no qualms about stripping off the signatures:
...
> So that makes me very curious.

Hmm, Works For Me too.  Searches for evidence...

Nope, I'm completely off-base here.  I wrote the exact opposite last
year:

On Sat, 10 Dec 2011 17:31:15 +1030 I wrote:
> But objdump doesn't care about appended data.
> objcopy and strip will remove it, of course, but without complaining.

Sorry for the noise,
Rusty.
