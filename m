Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab0JVUPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 16:15:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40976 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177Ab0JVUPL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 16:15:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=bq+lQvvGa+xSwy0YtKbJCP0gBVxrg6pMpQ9OhgqrTukf3ZPZ3pAsxzpSeTT9NEGxtR
         go4+WdgxdDJhlptu75s9DhDJUHhwMmZD4HNqYq1I8WMd/nqt1cT3nl6unAoBFCL/j98y
         l82FpS03CvRnDllGpix+tTmTt1CAi+PBRpwwE=
MIME-Version: 1.0
In-Reply-To: <20101021162410.5c0d6720.akpm@linux-foundation.org>
References: <1287250035-30404-1-git-send-email-vapier@gentoo.org>
 <20101021150250.f6499506.akpm@linux-foundation.org> <201010211823.38287.vapier@gentoo.org>
 <20101021155528.b3d6d027.akpm@linux-foundation.org> <AANLkTim6AFDw_1V9rtF4e_2tmgctbKHziQa-1e3=q7og@mail.gmail.com>
 <20101021162410.5c0d6720.akpm@linux-foundation.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 22 Oct 2010 16:14:49 -0400
X-Google-Sender-Auth: h5Sa5GEVyp2cb5CZcWVTCz8pBEc
Message-ID: <AANLkTikGbK7=eW9L4A62Rin-E3usq4Ke_dPoCdStDyEw@mail.gmail.com>
Subject: Re: [PATCH] lib/atomic64_test: do not build on non-atomic64 systems
To: Luca Barbieri <luca@luca-barbieri.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 19:24, Andrew Morton wrote:
> On Thu, 21 Oct 2010 19:04:36 -0400 Mike Frysinger wrote:
>> you can say "lazy" all you like.  i dont see the point in going that route.
>
> Try
>
>        grep HAVE arch/x86/Kconfig
>
> If all of those were instead to use some random #define which the
> particular feature happened to define in some header file then we would
> have a mess on our hands.

fun times.  new tact.

Luca: your new atomic64_t test build fails on all arches that lack
atomic64_t.  please fix.
-mike
