Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab0F3H5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 03:57:11 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50418 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab0F3H5J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 03:57:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Arn42++lF+5eVis8b4zDBgQp49fpw2ZpRKWLZIVqo6xutOGPhnvsVl6mZkTzKHfk7x
         Lh/zHWKVaUD5uxy5rBK/TKfMjF1gfJ9lhfFvulfqKLmAUvMq0nCeZFcesbTilKTlfAX2
         M9cJoqpBwTkDYpK3YrQv2tPO2xS3kwJRMJ3yM=
MIME-Version: 1.0
In-Reply-To: <20100630065440.GA1736@arch.tripp.de>
References: <alpine.DEB.2.00.1006300202190.30052@skynet.skynet.ie>
	<20100630065440.GA1736@arch.tripp.de>
Date: Wed, 30 Jun 2010 17:57:08 +1000
Message-ID: <AANLkTimXZ4gd9JtF0i0rXFnY8s4iRazKGbPgH4lhCDbS@mail.gmail.com>
Subject: Re: [git pull] drm fixes + agp + one fb patch
From: Dave Airlie <airlied@gmail.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 4:54 PM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
> On Wed, Jun 30, 2010 at 02:03:04AM +0100, Dave Airlie wrote:
>>
>> Hi Linus,
>>
>> one fb layer fix in a flag I introduced,
>>
>> the rest are drm fixes:
>> radeon fixes: the larger ones in the command stream checker for older cards,
>> which was causing a lot of userspace apps to fail. Also some powerpc server fixes.
>> along with some updates to the evergreen command stream checker introduced in -rc1.
>>
>> agp: fix issue with warning on memory allocation + fallback to vmalloc.
>> ttm: fix regression introduced in -rc1 in memory allocation paths.
>>
>> The following changes since commit 7e27d6e778cd87b6f2415515d7127eba53fe5d02:
>>
>>   Linux 2.6.35-rc3 (2010-06-11 19:14:04 -0700)
>>
>
> I've tested these patches and they break my setup (RS780). On reboot, the
> monitor goes straight to powersaving mode and no framebuffer is shown.

 Can you bisect which one does it? 2.6.35-rc3 works okay?

Dave.
