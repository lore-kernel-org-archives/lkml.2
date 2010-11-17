Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377Ab0KQGUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 01:20:52 -0500
Received: from 1wt.eu ([62.212.114.60]:47433 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755630Ab0KQGUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 01:20:51 -0500
Date: Wed, 17 Nov 2010 07:19:56 +0100
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kyle Moffett <kyle@moffetthome.net>, Marcus Meissner <meissner@suse.de>,
        linux-kernel@vger.kernel.org, tj@kernel.org, akpm@linux-foundation.org,
        hpa@zytor.com, mingo@elte.hu, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of attacking
Message-ID: <20101117061956.GD32484@1wt.eu>
References: <20101116104600.GA24015@suse.de> <AANLkTi=F1vbwpOzyN9o0nuRtsEUTQx2j3==kLu9j7Ccb@mail.gmail.com> <AANLkTikgb96oJCrF-5sBPMUTiNPbCMEGUkuGxAJ=g-Mx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikgb96oJCrF-5sBPMUTiNPbCMEGUkuGxAJ=g-Mx@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 09:58:44PM -0800, Linus Torvalds wrote:
> So I do think that it's worth closing these "small" holes. Anything
> that makes it more work to attack really _is_ improving things.

We must keep in mind that anything which requires more work as root
for common administration opens new holes. I don't think it's the
case for kallsyms, but I mean we should not try to lock too hard,
otherwise everyone will have a sudoers entry to do his work, and
that's even worse than current situation.

Willy

