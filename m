Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab2DRIWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 04:22:39 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:53668 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751086Ab2DRIWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 04:22:37 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX1/SjxFQsZvS/zCa55UkbpzR+ExcQCJxatuqDuZawC
	Wqus3hyjhEze1O
From: Sven Joachim <svenjoac@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel panic after suspend/resume
References: <CA+55aFzsjpJt09b6e4NA0T50M3w0xtASSYXz_=UWVDqKRywo=A@mail.gmail.com>
	<87pqb6fkji.fsf@turtle.gmx.de>
	<CA+55aFxhb6hriqHHwVtNeYHmtcy5JCEJX-zABBcG2Zjw_gawPw@mail.gmail.com>
	<201204172321.41095.rjw@sisk.pl>
Date: Wed, 18 Apr 2012 10:22:30 +0200
In-Reply-To: <201204172321.41095.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Tue, 17 Apr 2012 23:21:40 +0200")
Message-ID: <87hawhtpo9.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-17 23:21 +0200, Rafael J. Wysocki wrote:

> Well, commit fa4da365bc7772c kind of looks like it might be the source of
> this trouble.  Sven, can you try to revert it, please?

This seems to do the trick, thanks.

Cheers,
       Sven
