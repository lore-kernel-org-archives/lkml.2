Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760896Ab0HLTtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 15:49:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754412Ab0HLTto convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 15:49:44 -0400
MIME-Version: 1.0
In-Reply-To: <s5hvd7ftyl7.wl%tiwai@suse.de>
References: <s5hlj8dwrd7.wl%tiwai@suse.de> <AANLkTi=2N_P=zAM73a=dOBX6w0OzsgJi3TqRDu0LyZtB@mail.gmail.com>
 <s5hvd7ftyl7.wl%tiwai@suse.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Aug 2010 12:49:08 -0700
Message-ID: <AANLkTi=kc8FUJuGCTOsAObLmLhKKEUXbW8e0s_b74h+=@mail.gmail.com>
Subject: Re: [GIT PULL] sound update (#2) for 2.6.36
To: Takashi Iwai <tiwai@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 12:33 PM, Takashi Iwai <tiwai@suse.de> wrote:
>
> If this happens after the pull of my last request, it's possibly the
> commit eb541337b7a43822fce7d0c9d967ee149b2d9a96:
>    ALSA: hda - Make converter setups sticky
>
> Could you try to revert it?

I've done some more testing. If I 'cat' something directly to
/dev/audio, I do get sound. So I wonder whether it's some pulseaudio
problem, and I'll double-check that it's really the kernel (and not
the result of a "yum update", for example)

                            Linus
