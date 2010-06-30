Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab0F3GyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 02:54:11 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56348 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab0F3GyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 02:54:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DnMbXDJkYpT6KY36JtHS/HQJiaoUxpewAMRJIcW/QFGjlbA0sY1QOJqpSMm5xWP8az
         QYKqIItAIVwk2ZZASzlxCip+paOwTGVLCOQclGLv2rSy1gdTcJ4JMoOzz4M1lDU36Bay
         pG8mOd6zB4/HXjUSWDzW8G3T37Ay7/+IjYI20=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1001270917120.24253@localhost.localdomain>
References: <alpine.LFD.2.00.1001270327580.24253@localhost.localdomain>
	<1264605932-8540-1-git-send-email-chris@chris-wilson.co.uk>
	<alpine.LFD.2.00.1001270738220.24253@localhost.localdomain>
	<89k77n$ms73l9@fmsmga001.fm.intel.com>
	<alpine.LFD.2.00.1001270917120.24253@localhost.localdomain>
Date: Wed, 30 Jun 2010 16:54:07 +1000
Message-ID: <AANLkTilpK6FfgbgVf4e7jJSvVwVDVLfrxIy3WmgliuLK@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Selectively enable self-reclaim
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, earny@net4u.de,
       Roman Jarosz <kedgedev@gmail.com>, intel-gfx@lists.freedesktop.org,
       linux-kernel@vger.kernel.org, jcnengel@googlemail.com,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>, A Rojas <nqn1976list@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, rientjes@google.com,
       michael@reinelt.co.at, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 3:19 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Wed, 27 Jan 2010, Chris Wilson wrote:
>>
>> Yes, it survives a short torture test that leaks lots of bo objects from
>> X. Obviously this patch depends upon the new interface.
>
> All right. I'll apply my patch, since i'd rather have any half-way complex
> logic for handling mappings in the generic mm code. And then I'll apply
> yours, because now I can look at it without wanting to dig my eyes out.
>

Chris's patch has been reported to cause a regression in hibernate,

I haven't set up a reproducer yet, and it might be a stable issue
(someone bisected it in stable).

https://bugzilla.kernel.org/show_bug.cgi?id=13811

Hopefully I can spend some time tomorrow setting up a machine to test.

Dave.
