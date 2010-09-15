Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab0IONQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 09:16:18 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52169 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab0IONQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 09:16:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=pAldMxHdZDd1L7DNtsqMkFZ0bh54ogzBV35WPrYFCmBr1orQQgDq2mNOGijg1/ozub
         Ls6KRgQFz9+tY4mCR4tyRqzC7RpYQi+9CjxYW/XlOyECQkqO/ak7bZ2fd8UZ27pm0oJM
         JYwNBWnasIdRQ9ct6kelRypm/+YT68L6tNdlY=
MIME-Version: 1.0
In-Reply-To: <4C90C098.6070404@kernel.dk>
References: <1284554007-13077-1-git-send-email-namhyung@gmail.com> <4C90C098.6070404@kernel.dk>
From: Namhyung Kim <namhyung@gmail.com>
Date: Wed, 15 Sep 2010 22:15:56 +0900
Message-ID: <AANLkTi=E+jx+6-e+5LO+pnW4eZ51fSXTf01sEMXY9Ogm@mail.gmail.com>
Subject: Re: [PATCH] block: add assert_spin_locked() to ensure lock is held
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 21:48, Jens Axboe <axboe@kernel.dk> wrote:
> As far as I know, no such bug has ever occurred that I know
> of. So while I don't mind adding such instrumentation, there's
> little point to doing it when you are not seeing any usability
> problems in there. And all these paths (requeue less) are
> heavily used, so problems would appear quickly.
>

I didn't see any problems in there. I just thought
if a code has such a restriction, generally it is better
to have an explicit assertion in the code also
not only in comments. Since those functions are
EXPORTed ones I thought there will be a possibility
of misusing them, although they could be found
quickly without this facility. :-)


-- 
Regards,
Namhyung Kim
