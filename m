Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040Ab2CABR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 20:17:29 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:37517 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752184Ab2CABR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 20:17:28 -0500
Message-ID: <1330564646.23314.23.camel@joe2Laptop>
Subject: Re: [PATCH] get_maintainer.pl: Add support for moderated lists
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Weinberger <richard@nod.at>, Ian.Campbell@citrix.com,
        florian@mickler.org, linux-kernel@vger.kernel.org
Date: Wed, 29 Feb 2012 17:17:26 -0800
In-Reply-To: <20120229160254.eda62e01.akpm@linux-foundation.org>
References: <1330544962-995-1-git-send-email-richard@nod.at>
	 <1330545526.22465.5.camel@joe2Laptop> <4F4E8555.5040002@nod.at>
	 <20120229160254.eda62e01.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-29 at 16:02 -0800, Andrew Morton wrote:
> On Wed, 29 Feb 2012 21:06:45 +0100
> Richard Weinberger <richard@nod.at> wrote:
> 
> > Am 29.02.2012 20:58, schrieb Joe Perches:
> > > <shrug>  From my perspective, it's correct and simple.
> > > 
> > > Moderated lists just means your email may get delayed
> > > and you may get a "delayed due to moderation" email.
> > 
> > Most moderated lists are "moderated" by nobody and the patch
> > goes to /dev/null.
> 
> That's a big problem - we don't want people to send their fixes and bug
> reports into black holes.
> 
> So yes, I think that teaching get_maintainer to emit black hole
> warnings is a good idea.
> 
> Problem is, I don't think the string "moderated" explains the situation
> very well for the uninitiated :(

It's also false.  Most moderated lists in MAINTAINERS
(and I've probably send patches to most of them) are
in fact moderated.

My patches generally show up in their list archives.

