Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab2JKO5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 10:57:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:35288 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab2JKO5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 10:57:48 -0400
Date: Thu, 11 Oct 2012 11:57:38 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: Oliver Endriss <o.endriss@gmx.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PULL] Disintegrate UAPI for media
Message-ID: <20121011115738.76ac0ce3@infradead.org>
In-Reply-To: <20566.1349964331@warthog.procyon.org.uk>
References: <20121011093703.24b60232@infradead.org>
	<30699.1349789424@warthog.procyon.org.uk>
	<20121009183908.1e402a43@infradead.org>
	<201210111023.51311.o.endriss@gmx.de>
	<20566.1349964331@warthog.procyon.org.uk>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 11 Oct 2012 15:05:31 +0100
David Howells <dhowells@redhat.com> escreveu:

> Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> 
> > My understanding here is that, as the file location will change
> > with this series, your original concern is now void, as userspace
> > will require patches to use the new location. So, if we're willing
> > to do it, let's put this one-driver-only obsolete API on a separate
> > place.
> 
> As far as userspace is concerned, things will not change.  The header
> installation step will copy the uapi/ headers to the place it used to copy the
> non-uapi header.

Ah, ok. Then let's apply it as-is.

Cheers,
Mauro
