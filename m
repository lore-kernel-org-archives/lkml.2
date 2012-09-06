Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760144Ab2IFBPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 21:15:41 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59396 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab2IFBPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 21:15:40 -0400
MIME-Version: 1.0
In-Reply-To: <CACVxJT9fq=vsGukFiJaGj3qJFYbGvwOxXQL5f6PFi9RfjkBwrw@mail.gmail.com>
References: <20120717211411.GA2800@p183.telecom.by> <CACVxJT9fq=vsGukFiJaGj3qJFYbGvwOxXQL5f6PFi9RfjkBwrw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 5 Sep 2012 18:15:18 -0700
X-Google-Sender-Auth: vKBglrvfUBZNBvlxB1umbxUp5EU
Message-ID: <CA+55aFzpBKGUzmFWjLHRzCkV+oV6_XmtQevRpFG8kTp62GTeLw@mail.gmail.com>
Subject: Re: 3.5-rc7: nouveau doesn't X on NVC0
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ben Skeggs <bskeggs@redhat.com>, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ This got dropped somehow - it's in my draft folder. The bisection
may be irrelevant now: does it work with current git, since we've had
some nouveau changes? ]

On Tue, Aug 28, 2012 at 8:26 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> Ping!
>
> No X for me with 3.6-rc2.

Can you possibly bisect it, at least partially? Just knowing exactly
where it started might help the nouveau developers,

                Linus
