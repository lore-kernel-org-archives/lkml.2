Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151Ab0JIVfA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 17:35:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41825 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab0JIVe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 17:34:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=P6jD1+/GogXY5GZIm/IYRTL4TRLMrxxz+m7S0boY2AfNTD2TvefDaVXGczISIy7UmS
         DO/FSPa0Mymqe5+YM5sDqReXSx+N9kOvxmqh9M5h76ik+HO4u8Pp3NUuhkyDNiw89jfj
         rHY7BJm81TR5REDmz63JuoB4yKIskH9/boBWc=
MIME-Version: 1.0
Date: Sun, 10 Oct 2010 07:34:58 +1000
Message-ID: <AANLkTinyA=bSeSe7eavUb7fuSgM8m=QQFGqCrNtCGqKa@mail.gmail.com>
Subject: stable cc's in linux -next was Re: [BUG] x86: bootmem broken on SGI UV
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 4:39 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sat, Oct 9, 2010 at 11:06 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>>
>> It is too late for put in 2.6.36. Linus already had -rc7, and assume he will have final .36 this week.
>
> Anything that is worth tagging for stable is worth fixing before the
> final release (probably Wednesday).

Do we track people dong this at all? I wonder how many patches in
linux-next have cc: stable in them but haven't been submitted to
Linus,

I know in some cases people want to soak test them for a bit longer
but not sure how much actual coverage next provides.

Dave.
