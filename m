Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab3AGBRb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 20:17:31 -0500
Received: from ozlabs.org ([203.10.76.45]:59781 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317Ab3AGBRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 20:17:22 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael Kerrisk \(man-pages\)" <mtk.manpages@gmail.com>,
        David Howells <dhowells@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: init_module.2 man page ERRORS text for signed modules
In-Reply-To: <CAKgNAkjF+9d3_UhzOM-1H+F9W6UAhWDnugS__XzFiL-b2a3gyQ@mail.gmail.com>
References: <CAKgNAkjF+9d3_UhzOM-1H+F9W6UAhWDnugS__XzFiL-b2a3gyQ@mail.gmail.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 07 Jan 2013 11:44:02 +1030
Message-ID: <878v854wx1.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:

> Hi David, Rusty,
>
> Linux 3.7 added signed modules. As a consequence, init_module()
> acquired some new possible error returns. I've put together the text
> below to describe the new errors. Does the text look okay?

Looks good.  I liked the finit_module text, too.

Thanks!
Rusty.
