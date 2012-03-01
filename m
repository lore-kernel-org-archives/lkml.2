Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545Ab2CAADE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 19:03:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39253 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab2CAADB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 19:03:01 -0500
Date: Wed, 29 Feb 2012 16:02:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Weinberger <richard@nod.at>
Cc: Joe Perches <joe@perches.com>, Ian.Campbell@citrix.com,
        florian@mickler.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get_maintainer.pl: Add support for moderated lists
Message-Id: <20120229160254.eda62e01.akpm@linux-foundation.org>
In-Reply-To: <4F4E8555.5040002@nod.at>
References: <1330544962-995-1-git-send-email-richard@nod.at>
	<1330545526.22465.5.camel@joe2Laptop>
	<4F4E8555.5040002@nod.at>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Feb 2012 21:06:45 +0100
Richard Weinberger <richard@nod.at> wrote:

> Am 29.02.2012 20:58, schrieb Joe Perches:
> > <shrug>  From my perspective, it's correct and simple.
> > 
> > Moderated lists just means your email may get delayed
> > and you may get a "delayed due to moderation" email.
> 
> Most moderated lists are "moderated" by nobody and the patch
> goes to /dev/null.

That's a big problem - we don't want people to send their fixes and bug
reports into black holes.

So yes, I think that teaching get_maintainer to emit black hole
warnings is a good idea.

Problem is, I don't think the string "moderated" explains the situation
very well for the uninitiated :(

