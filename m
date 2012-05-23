Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933556Ab2EWGTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:19:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932910Ab2EWGTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:19:13 -0400
Message-ID: <1337753948.2225.2.camel@perseus.themaw.net>
Subject: Re: [PATCH] autofs4 - fix get_next_positive_subdir()
From: Ian Kent <ikent@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@linux.kernel.org>
Date: Wed, 23 May 2012 14:19:08 +0800
In-Reply-To: <CA+55aFwCESHx0d+ZEe-zi3PS6mkMaMng75Dnfit93cTwhb5gSg@mail.gmail.com>
References: <20120523024950.3905.89811.stgit@perseus.themaw.net>
	 <CA+55aFwCESHx0d+ZEe-zi3PS6mkMaMng75Dnfit93cTwhb5gSg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-22 at 19:53 -0700, Linus Torvalds wrote:
> On Tue, May 22, 2012 at 7:49 PM, Ian Kent <ikent@redhat.com> wrote:
> >
> > The locking for the list traversal in get_next_positive_subdir() is
> > wrong, so fix it.
> 
> As an explanation, this kind of thing is totally useless. It doesn't
> actually give any information at all. It's like saying "change
> locking"

OK, I'll fix that and re-submit.

Ian

