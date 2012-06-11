Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab2FKDuL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 23:50:11 -0400
Received: from linux-sh.org ([111.68.239.195]:49100 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753566Ab2FKDuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 23:50:09 -0400
Date: Mon, 11 Jun 2012 12:50:05 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 1/6] sh: fix compiler warning by properly inlining
 flat_set_persistent()
Message-ID: <20120611035005.GC10170@linux-sh.org>
References: <1339229611-2326-1-git-send-email-elezegarcia@gmail.com>
 <20120609091426.GA10170@linux-sh.org>
 <CALF0-+U-FHtb3Z+JEHoY9Jm9yhgeTasQR0nX5AwVM1Ah1+JKAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALF0-+U-FHtb3Z+JEHoY9Jm9yhgeTasQR0nX5AwVM1Ah1+JKAg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2012 at 06:33:10PM -0300, Ezequiel Garcia wrote:
> On Sat, Jun 9, 2012 at 6:14 AM, Paul Mundt <lethal@linux-sh.org> wrote:
> > On Sat, Jun 09, 2012 at 05:13:26AM -0300, Ezequiel Garcia wrote:
> >> This patch removes the following warning:
> >> fs/binfmt_flat.c:752: warning: unused variable ???persistent???
> >> There is neither change in functionality, nor extra code generated.
> >>
> >> Cc: Paul Mundt <lethal@linux-sh.org>
> >> Cc: <linux-sh@vger.kernel.org>
> >> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> >
> > That's what the cast was for, with what gcc version did that stop
> > working?
> 
> I just realized that I should send a v2 (not the whole series just this one)
> correcting the commit message, since there wasn't a warning to fix
> in first place.
> 
> I'll do this soon.

If there's no warning then the point of the patch eludes me. There's
nothing wrong with consistency, but attempting to fix that which isn't
broken in the name of consistency borders a bit too closely on pointless
busy work for my liking.
