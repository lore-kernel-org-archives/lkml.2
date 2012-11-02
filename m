Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab2KBEZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 00:25:20 -0400
Received: from ozlabs.org ([203.10.76.45]:51030 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab2KBEZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 00:25:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Josh Boyer <jwboyer@redhat.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] MODSIGN: Add modules_sign make target
In-Reply-To: <20121101112535.GL6627@hansolo.jdub.homelinux.org>
References: <20121031135605.GJ6627@hansolo.jdub.homelinux.org> <87zk314w1t.fsf@rustcorp.com.au> <20121101112535.GL6627@hansolo.jdub.homelinux.org>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 02 Nov 2012 13:49:14 +1030
Message-ID: <87ip9o4rpp.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Boyer <jwboyer@redhat.com> writes:

> On Thu, Nov 01, 2012 at 06:03:18PM +1030, Rusty Russell wrote:
>> Josh Boyer <jwboyer@redhat.com> writes:
>> 
>> > If CONFIG_MODULE_SIG is set, and 'make modules_sign' is called then this
>> > patch will cause the modules to get a signature appended.  The make target
>> > is intended to be run after 'make modules_install', and will modify the
>> > modules in-place in the installed location.  It can be used to produce
>> > signed modules after they have been processed by distribution build
>> > scripts.
>> >
>> > Signed-off-by: Josh Boyer <jwboyer@redhat.com>
>> 
>> It's a bit of a niche case, but applied.
>
> Thanks.  Whether you consider RPM built kernels niche or not doesn't
> matter to me.  Having this upstream is one less patch we have to carry
> so I appreciate it a lot.

My comment was more that this relies on eu-strip, because we always
sign modules on installation, so you need eu-strip to *unsign* them
(strip won't do it, BTW).

More general would be a modules_install_unsigned target to match this,
but since noone would use it, let's not write it :)

Cheers,
Rusty.
