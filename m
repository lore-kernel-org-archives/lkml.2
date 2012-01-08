Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab2AHVnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 16:43:19 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:53546 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754504Ab2AHVnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 16:43:19 -0500
Message-ID: <1326058974.5372.4.camel@joe2Laptop>
Subject: Re: Please merge two small bug fix patches from linux-next
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesper Juhl <jj@chaosbits.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>
Date: Sun, 08 Jan 2012 13:42:54 -0800
In-Reply-To: <CA+55aFwO9Wtq=NEpMskW-2wrWZAGh-C6VBXENA3LtFOk=tUwgQ@mail.gmail.com>
References: <alpine.LNX.2.00.1201082028140.24030@swampdragon.chaosbits.net>
	 <CA+55aFwO9Wtq=NEpMskW-2wrWZAGh-C6VBXENA3LtFOk=tUwgQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-01-08 at 13:26 -0800, Linus Torvalds wrote:
> On Sun, Jan 8, 2012 at 11:51 AM, Jesper Juhl <jj@chaosbits.net> wrote:
> > Below are two patches that have been in linux-next for ages (via akpm's
> > tree). They are prette simple, straight-up, bug fixes. They have been
> > submitted to maintainers multiple times over (IIRC at least the past
> > year), but for some reason the maintainers seem uninterested in picking
> > them up (or even responding to them).
[]
> they seem to have Andrew's sign-off, so I'd have expected them to
> come through Andew. What's up?

>From my perspective, the issue lies with James'
apparent desire to keep scsi tree changes as close
to zero as possible.

Many obvious corrections to scsi defects have gone
unapplied.

