Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab1JJWKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 18:10:31 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:41545 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab1JJWKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 18:10:30 -0400
Date: Mon, 10 Oct 2011 15:10:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        apw@canonical.com
Subject: Re: [PATCH] checkpatch: warn on found Change-Id lines
Message-Id: <20111010151027.bc397b85.akpm@linux-foundation.org>
In-Reply-To: <1318266599.27825.12.camel@Joe-Laptop>
References: <1318226216-5317-1-git-send-email-olof@lixom.net>
	<1318266599.27825.12.camel@Joe-Laptop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Oct 2011 10:09:59 -0700
Joe Perches <joe@perches.com> wrote:

> On Sun, 2011-10-09 at 22:56 -0700, Olof Johansson wrote:
> > Some external projects use repo, which uses a special-format Change-Id
> > field in the commit message for some internal bookkeeping (to re-associate
> > patches back to review entries, etc).
> 
> I believe Andrew has a patch from me in his queue
> somewhere that tries to isolate the commit message
> and does a couple of checks just on that content.

I haven't seen a changelogged, signed-off, cc'ed-to-mailing-list
version.

Possibly gmail munched it.  I've been having a lot of inexplicable email
vanishings lately :(
