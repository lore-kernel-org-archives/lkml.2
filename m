Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab2JTQlz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 12:41:55 -0400
Received: from stringer.orebokech.com ([88.190.240.207]:42120 "EHLO
	stringer.orebokech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2JTQly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 12:41:54 -0400
From: Romain Francoise <romain@orebokech.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Boyer <jwboyer@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        pjones@redhat.com
Subject: Re: RFC: sign the modules at install time
Organization: orebokech dot com
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com>
	<3179.1350512382@warthog.procyon.org.uk>
	<CA+55aFzEH1jguw8NB90si2uxvyO63FuKPOc8wiEPRCYwruSzRg@mail.gmail.com>
	<87a9vko0z7.fsf@rustcorp.com.au>
	<20121018121154.GE2934@hansolo.jdub.homelinux.org>
	<CA+55aFy677k6zvkc9n_2e6OEmOx-S1AYbOumkUOSkrE8Q+aUKw@mail.gmail.com>
Date: Sat, 20 Oct 2012 18:41:52 +0200
In-Reply-To: <CA+55aFy677k6zvkc9n_2e6OEmOx-S1AYbOumkUOSkrE8Q+aUKw@mail.gmail.com>
	(Linus Torvalds's message of "Thu, 18 Oct 2012 09:29:16 -0700")
Message-ID: <874nlpksdr.fsf@silenus.orebokech.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> I like how the default makefiles do that "create and use random key"
> thing by default. THAT is what I want to see.

Yes, however the key generation itself is horribly verbose and doesn't mix
very well with the output of a parallel build. Now that the modules are
signed at install time, presumably the key should be generated then as
well, and the output cleaned up to look like normal Kbuild messages (with
support for V=1 for the curious).
