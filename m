Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760245Ab0HLPY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 11:24:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64942 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760237Ab0HLPYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 11:24:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=mm4mCXUjnmMvPVWZPWlsAShh3VzxeR/M/j7ZlLh7AtR4dlGt7I451icNonM0CDWiBt
         E2Dj1c4o6IlRZHE+YYweuEOPjsoVv3eyV4oDBbqMwyB/So95Qal2jIIJTxIE7Iw+X0aK
         hqBzAFbVzXeYJ1T2XfOupXQzI41nALVWU6ypA=
MIME-Version: 1.0
In-Reply-To: <AANLkTik1K3AMQhT+HA7z33A3BpE+UXPJ+a14qNT=mgz7@mail.gmail.com>
References: <AANLkTik1K3AMQhT+HA7z33A3BpE+UXPJ+a14qNT=mgz7@mail.gmail.com>
Date: Thu, 12 Aug 2010 08:24:53 -0700
Message-ID: <AANLkTikEm0=pp_CgBLHyUvnDjGiupADOnm3sOcmUR_hf@mail.gmail.com>
Subject: Re: [ANNOUNCE] [REALTIME] 2.6.33.8-rt30-jk
From: Mark Knecht <markknecht@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 8:05 AM, John Kacur <jkacur@redhat.com> wrote:
> I'm announcing the release of 2.6.33.8-rt30-jk
> The -jk indicates that it is my own -rt version, and not the official
> one that Thomas releases.
> However, it would be great if you tested it and reported your results.
>
> You can fetch it via git from
> git://git.kernel.org/pub/scm/linux/kernel/git/jkacur/jk-2.6.git
> branch: rt/2.6.33-jk
>
> Thanks, enjoy!

;-) Any chance of you hacking out a 2.6.35 version? ;-)

I've got a new i980x 6-core, 12-thread machine that problems
recognizing all the disk drives on 2.6.34 without patches, but works
very well on 2.6.35. I'd love to play with the real-time kernel on it
doing audio.

Cheers,
Mark
