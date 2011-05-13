Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab1EMIVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 04:21:00 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42923 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757894Ab1EMIU5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 04:20:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PCCDxU2Y5uua4fa+efNnNuvrwN9zqPSI2gLsb69lH3H28wcDW2iql//raZgB/Uoy0H
         Uw8kftTmA2FBLdTp2VNUxKOeFd5YVy9FFJJF3FKC/TtTuAXW9dzc50JOzC2uJHUhwipQ
         GoAs0GjO8UEyh00mBGnq5s9MupXbnJueiuXSo=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=kb_m-CfrpnD8qQTVYLGaDdgy_tg@mail.gmail.com>
References: <BANLkTi=kb_m-CfrpnD8qQTVYLGaDdgy_tg@mail.gmail.com>
Date: Fri, 13 May 2011 10:20:54 +0200
Message-ID: <BANLkTikMeyRTOB9q4PEAYWnZRZfk3wg=kQ@mail.gmail.com>
Subject: Re: AAARGH bisection is hard (Re: [2.6.39 regression] X locks up hard
 right after logging in)
From: Christian Couder <christian.couder@gmail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, git@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Shuang He <shuang.he@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 7:15 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>
> OK, this sucks.  In the course of bisecting this, I've hit two other
> apparently unrelated bugs that prevent my from testing large numbers
> of kernels.  Do I have two questions:
>
> 1. Anyone have any ideas from looking at the log?
>
> It looks like most of what's left is network code, so cc netdev.
>
> 2.  The !&$#@ bisection is skipping all over the place.  I've seen
> 2.6.37 versions and all manner of -rc's out of order.  Linus, and
> other people who like pontificating about git bisection: is there any
> way to get the bisection to follow Linus' tree?  I think that if
> bisect could be persuaded to consider only changes that are reached by
> following only the *first* merge parent all the way from the bad
> revision to the good revision, then the bisection would build versions
> that were at least good enough for Linus to pull and might have fewer
> bisection-killing bugs.
>
> (This isn't a new idea [1], and git rev-list --bisect --first-parent
> isn't so bad except that it doesn't bisect.)

Did you forget to put the reference [1] in your email? Was it this one
you were thinking about:

http://thread.gmane.org/gmane.comp.version-control.git/165433/

?

Thanks,
Christian.
