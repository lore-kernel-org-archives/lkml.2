Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab2IIOXP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 10:23:15 -0400
Received: from stringer.orebokech.com ([88.190.240.207]:41756 "EHLO
	stringer.orebokech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab2IIOXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 10:23:13 -0400
From: Romain Francoise <romain@orebokech.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: Linux 3.6-rc5
Organization: orebokech dot com
References: <CA+55aFwnPfdyTTG6WTuhChomg=t9nSS18xracq3iQ3F5+PWOog@mail.gmail.com>
	<87har7h84h.fsf@silenus.orebokech.com>
	<20120909155424.862635h7ncykg9s0@www.81.fi>
Date: Sun, 09 Sep 2012 16:23:11 +0200
In-Reply-To: <20120909155424.862635h7ncykg9s0@www.81.fi> (Jussi Kivilinna's
	message of "Sun, 09 Sep 2012 15:54:24 +0300")
Message-ID: <87wr038ecw.fsf@silenus.orebokech.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jussi Kivilinna <jussi.kivilinna@mbnet.fi> writes:

> Does reverting e46e9a46386bca8e80a6467b5c643dc494861896 help?

It does, thanks.
