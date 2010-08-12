Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915Ab0HLT6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 15:58:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753428Ab0HLT6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 15:58:16 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTi=kc8FUJuGCTOsAObLmLhKKEUXbW8e0s_b74h+=@mail.gmail.com>
References: <s5hlj8dwrd7.wl%tiwai@suse.de> <AANLkTi=2N_P=zAM73a=dOBX6w0OzsgJi3TqRDu0LyZtB@mail.gmail.com>
 <s5hvd7ftyl7.wl%tiwai@suse.de> <AANLkTi=kc8FUJuGCTOsAObLmLhKKEUXbW8e0s_b74h+=@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Aug 2010 12:57:20 -0700
Message-ID: <AANLkTinfEQ-ojY7GbBgLPQU-6iFZ+KVQ9LU1h9xBMQMf@mail.gmail.com>
Subject: Re: [GIT PULL] sound update (#2) for 2.6.36
To: Takashi Iwai <tiwai@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 12:49 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I've done some more testing. If I 'cat' something directly to
> /dev/audio, I do get sound. So I wonder whether it's some pulseaudio
> problem, and I'll double-check that it's really the kernel (and not
> the result of a "yum update", for example)

It's definitely kernel-related.

kernel v2.6.35-05791-g45d7f32 works. v2.6.35-7786-gad41a1e does not.
And reverting that "Make converter setups sticky" commit doesn't make
any difference.

I'll start bisecting it.

                            Linus
