Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab0FGU0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 16:26:25 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46082 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab0FGU0Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 16:26:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HpUv7taC3gKHB4CQCUlZEeLM8+2/79OzgD9J8FLts18i0xAVtcHvmNlupXKi+zce/k
         3/2fEeqhB4CQlQY9jeDfBQSNK0MexmGpz4XtE2efUhGIvnz7cuVfKPZ/vXJjnxjwxcph
         4yTtgMaAS3Cd8RMVvSQdKiGUW0knZmKKTCfng=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1006071057300.3515@i5.linux-foundation.org>
References: <alpine.DEB.2.00.1006070404510.29029@skynet.skynet.ie>
	<alpine.LFD.2.00.1006071057300.3515@i5.linux-foundation.org>
Date: Tue, 8 Jun 2010 06:26:20 +1000
Message-ID: <AANLkTimSFtaDzUPDEq4Z2J4O5sFG4vDkFHqs1eA1wG44@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 8, 2010 at 4:00 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Mon, 7 Jun 2010, Dave Airlie wrote:
>>
>> 3 regressions fixes, one radeon loading on IGP, one i865 loading, one and
>> an evergreen userspace interaction workaround.
>
> This is:
>
>         26 files changed, 372 insertions(+), 66 deletions(-)
>
> and there are apparently several reports of known problems (the problem
> with modesetting) that isn't even addressed.

Okay, not sure what the addressed regression you are talking about, do
you want  regression fixes early like you always say or do you want to
wait until I have every regression reported fixes before I send a pull
request?

I'll rebase the tree today (which means it will be tested less than
what I originally sent you, inconsistent messages much?)..

> So please. Just make me a tree that has regression fixes _only_. I'm not
> AT ALL interested in "it is useful to report the gpu temp". If it was so
> useful, and if it was ready before the merge window, it should hav gone in
> then. That clearly wasn't the case, so it's not going in now either.

I really hope you do this, if I find one thing going into your tree
after today that isn't a regression fix I'll send revert patches if
that'll help.

Dave.
