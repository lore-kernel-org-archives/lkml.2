Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab1BIX5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 18:57:38 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47939 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986Ab1BIX5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 18:57:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=i+PaA85PxlC0SHGquaj3YGHn3+ImjNevZjQTvSsfUE2IvXwTfXHPDO5z5FgeFL0tGB
         sJYab2BF8d3OVt1Qyx3TEOJI3uA0zesdKh/m8oJedIQTmdHFIDpLVc/XBTgCah4yrj9X
         aX3ASyi+3mM9+PAlNPSeU2hz5H+RbXHiIlGHk=
MIME-Version: 1.0
In-Reply-To: <5c529b08-cf36-43c7-b368-f3f602faf358@default>
References: <AANLkTi=CEXiOdqPZgQZmQwatHqZ_nsnmnVhwpdt=7q3f@mail.gmail.com>
	<AANLkTimm8o6FnDon=eMTepDaoViU9tjteAYE9kmJhMsx@mail.gmail.com>
	<5c529b08-cf36-43c7-b368-f3f602faf358@default>
Date: Thu, 10 Feb 2011 08:57:36 +0900
Message-ID: <AANLkTinwZJrAWo_Fat3e6WwLn+MPdZyFVgT6sckLCUo3@mail.gmail.com>
Subject: Re: [PATCH V2 2/3] drivers/staging: zcache: host services and PAM services
From: Minchan Kim <minchan.kim@gmail.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: gregkh@suse.de, Chris Mason <chris.mason@oracle.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        matthew@wil.cx, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        ngupta@vflare.org, jeremy@goop.org,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        riel@redhat.com, Konrad Wilk <konrad.wilk@oracle.com>, mel@csn.ul.ie,
        kosaki.motohiro@jp.fujitsu.com, sfr@canb.auug.org.au,
        wfg@mail.ustc.edu.cn, tytso@mit.edu, viro@zeniv.linux.org.uk,
        hughd@google.com, hannes@cmpxchg.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 1:39 AM, Dan Magenheimer
<dan.magenheimer@oracle.com> wrote:
>
>
>> From: Minchan Kim [mailto:minchan.kim@gmail.com]
>
>> As I read your comment, I can't find the benefit of zram compared to
>> frontswap.
>
> Well, I am biased, but I agree that frontswap is a better technical
> solution than zram. ;-)  But "dynamic-ity" is very important to
> me and may be less important to others.
>
> I thought of these other differences, both technical and
> non-technical:
>
> - Zram is minimally invasive to the swap subsystem, requiring only
>  one hook which is already upstream (though see below) and is
>  apparently already used by some Linux users.  Frontswap is somewhat

Yes. I think what someone is using it is a problem.

>  more invasive and, UNTIL zcache-was-kztmem was posted a few weeks
>  ago, had no non-Xen users (though some distros are already shipping
>  the hooks in their kernels because Xen supports it); as a result,
>  frontswap has gotten almost no review by kernel swap subsystem
>  experts who I'm guessing weren't interested in anything that
>  required Xen to use... hopefully that barrier is now resolved
>  (but bottom line is frontswap is not yet upstream).

That's why I suggested to remove frontswap in this turn.
If any swap experts has a interest, maybe you can't receive any ack or
review about the part in this series. Maybe  maintainers ends up
hesitating the merge.

If zcache except frontswap is merged into mainline or receive enough
review, then you can try merging frontswap as further step.

Thanks.

-- 
Kind regards,
Minchan Kim
