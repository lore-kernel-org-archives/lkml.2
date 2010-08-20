Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab0HTJQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 05:16:28 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:39728 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab0HTJQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 05:16:25 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: Eric Paris <eparis@redhat.com>, Andreas Gruenbacher <agruen@suse.de>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: struct fanotify_event_metadata
References: <m21va1ozqx.fsf@igel.home>
	<201008191644.29299.tvrtko.ursulin@sophos.com>
	<1282240426.21419.1716.camel@acb20005.ipt.aol.com>
	<201008201002.16235.tvrtko.ursulin@sophos.com>
X-Yow: Should I do my BOBBIE VINTON medley?
Date: Fri, 20 Aug 2010 11:16:22 +0200
In-Reply-To: <201008201002.16235.tvrtko.ursulin@sophos.com> (Tvrtko Ursulin's
	message of "Fri, 20 Aug 2010 10:02:15 +0100")
Message-ID: <m3pqxd7ift.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tvrtko Ursulin <tvrtko.ursulin@sophos.com> writes:

> Shrink pid field in the fanotify_event_metadata to 32-bit to match
> the kernel representation. Pull mask field up since it logically
> comes before event auxiliary data and also makes for a nicer
> alignment.

That won't buy you much wrt. alignment though, due to the packed
attribute.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
