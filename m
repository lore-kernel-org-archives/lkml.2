Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab1FJFyI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 01:54:08 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59302 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1FJFyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 01:54:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=KflTOFH0u+XGTHcht3ddkMMpPgpp0hvtZZJcdRVlucVTqmYn50Nny/4EuMc8spuCFI
         KPBANFV3t2O9XKXNn/UqUQ6gS507QkbUcq0iUG9VbrGUfNspC6I+YdQqoCZ+ADyBAUlo
         L9x+nR1My4TXWWXFruei43oQsH3pHWJ2wBGKk=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=wQaUSagZjptGnvUHNpJeMm0C6yw@mail.gmail.com>
References: <20110609214241.GA4849@sepie.suse.cz> <BANLkTim84t=yeqykZydEjHrVYGnO4xc5ew@mail.gmail.com>
 <BANLkTi=qaA_AMvq_78eon3Lr86wT2R497g@mail.gmail.com> <BANLkTinbXpFp43+EebWbWvs1Uu5wWvhxQQ@mail.gmail.com>
 <BANLkTinKMmYG7=KBHr2LfOYzcgbtszwy5g@mail.gmail.com> <BANLkTinQ2mL1eNPzMHjDjXnLyv58annZmA@mail.gmail.com>
 <BANLkTi=wQaUSagZjptGnvUHNpJeMm0C6yw@mail.gmail.com>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Thu, 9 Jun 2011 22:53:34 -0700
X-Google-Sender-Auth: GQrEPA2f5jPn4HHAn_bvpeQ6V80
Message-ID: <BANLkTinZGuOE3G5Ro0=LB9Y8wcHVgk-3ug@mail.gmail.com>
Subject: Re: [GIT] kbuild fixes for 3.0
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, pefoley2@verizon.net,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 10:16 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Beside that, no matter what, you are about to break
> `/usr/sbin/sensors-detect' (from my Fedora 14), which rely on a 3
> digits version number:

Is there really any compelling technical reason to _not_ have Linus
release the kernels with a superfluous .0 on the end, with the
understanding that the -stable team gets to increment it for their
future releases? It'd make every kernel.org release exactly three
dotted decimals from here on out, which certainly simplifies things.

It seems like we're just borrowing trouble here by trying to drop it
down to two numbers.

(Not, mind you, that I give a damn at all one way or the other, but it
feels like you all are going to be spending a lot of time tripping
over poor assumptions in userspace rather than doing actual work.)

~r.
