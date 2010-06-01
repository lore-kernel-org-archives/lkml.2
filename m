Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab0FAU5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:57:15 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40420 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab0FAU5L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:57:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cR38batlWGHAlII2CuUfZvAkbSnXho+c8SDNW2/MaIq7TnfqQwOi5YXpClnUrhzRgO
         ewFyUXn7Czmy9ilI6zOHX7g8QUVS5ADiOIHqmSOwgRNvioZaUufH4amRegL683a+Nz5M
         BbBqpLJLCaRgy/pUMTAw3E5k4dPPqlzabdEGM=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1006011204270.8175@i5.linux-foundation.org>
References: <20100601185937.5188.77506.stgit@warthog.procyon.org.uk> 
	<alpine.LFD.2.00.1006011204270.8175@i5.linux-foundation.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 1 Jun 2010 16:52:02 -0400
Message-ID: <AANLkTim_XTH-vhUx1em50GvfBSA4_UhlSJqtP46wh8F9@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH] NOMMU: Add '[stack]' label to 
	/proc/pid/maps output
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>,
       uclinux-dist-devel@blackfin.uclinux.org, akpm@linux-foundation.org,
       uclinux-dev@uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 1, 2010 at 15:07, Linus Torvalds wrote:
> On Tue, 1 Jun 2010, David Howells wrote:
>> Add support to the NOMMU /proc/pid/maps file to show which mapping is the stack
>> of the original thread after execve.  This is largely based on the MMU code.
>
> Umm? The MMU code that we _reverted_?

to be fair, this patch was written a few kernel revisions ago and
you're referring to commit merged a few weeks ago ...

> It turns out to be totally useless, since people put stacks in various
> different places, and the values the kernel does see end up not even being
> the "real" stack top.
>
> See commit 34441427aab4bdb3069a4ffcda69a99357abcb2e.
>
> Just don't do it.

but i dont think we're talking the same thing.  that commit refers to
[threadstack].  afaict, [stack] is still in there.
-mike
