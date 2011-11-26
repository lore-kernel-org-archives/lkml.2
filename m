Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab1KZJ6M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 04:58:12 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36726 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab1KZJ6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 04:58:11 -0500
MIME-Version: 1.0
In-Reply-To: <86sjlccchg.fsf@sumi.keithp.com>
References: <CAGPN=9THOv-M4Td4haE94uDcsAjW3eGMG7ioLeu+p8xUOBPd7w@mail.gmail.com>
	<861usye0og.fsf@sumi.keithp.com>
	<CAGPN=9ROa_Pf242jxPy-6XfmFNW3+sCMj6M+pFbw+wgCX3tu1Q@mail.gmail.com>
	<86sjlccchg.fsf@sumi.keithp.com>
Date: Sat, 26 Nov 2011 10:58:11 +0100
Message-ID: <CAGPN=9RY7h2MTat4pND=k2D6PWZEC5SFXdvOjs1sd89+1hoRVQ@mail.gmail.com>
Subject: Re: i915: 3.2 rc1/2 KMS regression
From: Patrik Kullman <patrik.kullman@gmail.com>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, booting the broken kernel freezes the machine unless I specify
i915.modeset=0.Do you want a log in that configuration?
I will provide the logs next week when I have my charger back...
2011/11/25 Keith Packard <keithp@keithp.com>
>
> On Fri, 25 Nov 2011 18:29:31 +0100, Patrik Kullman <patrik.kullman@gmail.com> wrote:
> > Ok, so I've now bisected, and it turns out that
> > dc22ee6fc18ce0f15424e753e8473c306ece95c1 is the first bad revision.
> >
> > Would it be safe to checkout 3.2-rc3 and git revert
> > dc22ee6fc18ce0f15424e753e8473c306ece95c1 (to test that it's the only
> > bad commit) ?
>
> Yes, that would be very useful. Please send kernel logs with drm.debug=4
> for an older working kernel, a broken kernel and a patched
> kernel with this commit reverted.
>
> --
> keith.packard@intel.com
