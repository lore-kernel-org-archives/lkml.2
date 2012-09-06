Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760174Ab2IFBdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 21:33:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39854 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab2IFBdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 21:33:16 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzpBKGUzmFWjLHRzCkV+oV6_XmtQevRpFG8kTp62GTeLw@mail.gmail.com>
References: <20120717211411.GA2800@p183.telecom.by>
	<CACVxJT9fq=vsGukFiJaGj3qJFYbGvwOxXQL5f6PFi9RfjkBwrw@mail.gmail.com>
	<CA+55aFzpBKGUzmFWjLHRzCkV+oV6_XmtQevRpFG8kTp62GTeLw@mail.gmail.com>
Date: Thu, 6 Sep 2012 11:33:16 +1000
Message-ID: <CAPM=9tzVoJdmhJTmLivKku77OxuXfpX66GDET8L0pDD1ffqt8w@mail.gmail.com>
Subject: Re: 3.5-rc7: nouveau doesn't X on NVC0
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Ben Skeggs <bskeggs@redhat.com>,
        linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 6, 2012 at 11:15 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> [ This got dropped somehow - it's in my draft folder. The bisection
> may be irrelevant now: does it work with current git, since we've had
> some nouveau changes? ]
>
> On Tue, Aug 28, 2012 at 8:26 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>> Ping!
>>
>> No X for me with 3.6-rc2.

Can you try -rc4?

Ben thinks the pcopy fix should fix it.

Dave.
