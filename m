Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791Ab0HDMyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 08:54:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57039 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932703Ab0HDMyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 08:54:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=T9CTneY/l8KFrY6zYeZriCQl18NOA6RevQhIVQ9bQEuHGM9qCGgww1/ZHUnGljX032
         DYotBORbEIbMN0P4s5qO3AS4IMU5qhRFczReA8vnNxAQNYxD+OulhvaXG9FZeKcvZ/xM
         bKymqO8thLaTRgQjmX53fpp8M3JI/GwPWQWiA=
MIME-Version: 1.0
In-Reply-To: <1280926108-24668-1-git-send-email-virtuoso@slind.org>
References: <1280926108-24668-1-git-send-email-virtuoso@slind.org>
Date: Wed, 4 Aug 2010 14:54:12 +0200
Message-ID: <AANLkTimmD1wijmyiSY8xHLyr_fQF52LyUpn3fmT1W_3=@mail.gmail.com>
Subject: Re: [PATCH] [RFC] notify userspace about time changes
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Alexander Shishkin <virtuoso@slind.org>
Cc: lkml@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Kacur <jkacur@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 4, 2010 at 2:48 PM, Alexander Shishkin <virtuoso@slind.org> wrote:
> Certain userspace applications (like "clock" desktop applets or ntpd) might
> want to be notified when some other application changes the system time. It
> might also be important for an application to be able to distinguish between
> its own and somebody else's time changes.

Why not implementing somtehing like http://lwn.net/Articles/323658/ a
la plan 9 with a poll callback ?

It will be plan9 compatible and so unix

Bastien
