Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab1JSDFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 23:05:18 -0400
Received: from ozlabs.org ([203.10.76.45]:49809 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033Ab1JSDFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 23:05:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Michal Schmidt <mschmidt@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] params: make dashes and underscores in parameter names truly equal
In-Reply-To: <4E9DCCEC.4090105@xenotime.net>
References: <1318197817-20964-1-git-send-email-mschmidt@redhat.com> <8739exg588.fsf@rustcorp.com.au> <4E96F887.5050103@redhat.com> <87obxfq7bd.fsf@rustcorp.com.au> <4E9DCCEC.4090105@xenotime.net>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 19 Oct 2011 13:30:18 +1030
Message-ID: <87r529adod.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011 12:01:00 -0700, Randy Dunlap <rdunlap@xenotime.net> wrote:
> Well, that could have just been my misunderstanding, but I think that this
> patch is the right thing to do.  Thanks.

It does two things:
1) It fixes early_params to be case-insensitive.  Good.
2) It fixes the (obsolete) __setup() to be case-insensitive.

We should finally get rid of __setup, then we wouldn't need the second
part.

Cheers,
Rusty.

