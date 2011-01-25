Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab1AYW0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 17:26:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752936Ab1AYW0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 17:26:16 -0500
MIME-Version: 1.0
In-Reply-To: <4D3F4804.6070508@redhat.com>
References: <4D3E4DD1.60705@teksavvy.com> <20110125042016.GA7850@core.coreip.homeip.net>
 <4D3E5372.9010305@teksavvy.com> <20110125045559.GB7850@core.coreip.homeip.net>
 <4D3E59CA.6070107@teksavvy.com> <4D3E5A91.30207@teksavvy.com>
 <20110125053117.GD7850@core.coreip.homeip.net> <4D3EB734.5090100@redhat.com>
 <20110125164803.GA19701@core.coreip.homeip.net> <AANLkTi=1Mh0JrYk5itvef7O7e7pR+YKos-w56W5q4B8B@mail.gmail.com>
 <20110125205453.GA19896@core.coreip.homeip.net> <4D3F4804.6070508@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 26 Jan 2011 08:25:25 +1000
Message-ID: <AANLkTikBzqtb01G=hMJO9bcctnQ_J21OR3DfxDbufsVd@mail.gmail.com>
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mark Lord <kernel@teksavvy.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 8:00 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
>
> See, it will only look into the 16-bits scancode space. There are several remote
> controllers with 24 bits and 32 bits, so the tool is already broken anyway.

Mauro, stop blathering.

The problem is that the tool used to work with OLD DEVICES AND SETUPS
that used to work. That broke. It needs to get fixed.

We do not change user-land ABI. Not now, not ever. And no, "the tool
is broken" is NOT an excuse. Bringing it up as one is unacceptable.
The fact that there are devices that didn't use to be supported at all
that don't work with the old tool has absolutely ZERO relevance,
because that's not a regression.

No regressions. No excuses. No "user-land is broken", however much you
disagree with it.

                  Linus
