Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760019Ab0JZP71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 11:59:27 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46450 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759948Ab0JZP70 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 11:59:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=EqIcVxQax7Eu0pRUNYj+d/AQjxuxysNfPwCw//AelrA1n+vUs3YIue4t1Z3cMmF8Kb
         BXHUMx2jAvZNLaXmrB8fMjP0nhEpvr3pP5Coh302Gd6cUZFdwzIcl8vvTdm9Aoyd/TjX
         WTYq0lYFCXHk0fW8cPiiTPpvMTrbFIywEUEK4=
MIME-Version: 1.0
In-Reply-To: <20101026123552.GA4604@sig21.net>
References: <20101025190358.AEC6840F97@repository3.orbit-lab.org> <20101026123552.GA4604@sig21.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 26 Oct 2010 08:59:04 -0700
Message-ID: <AANLkTimzUKj=C9PxGs1PkQy_KWu0PGKd1zv_m-ZpWaEm@mail.gmail.com>
Subject: Re: Compat-wireless release for 2010-10-25 is baked
To: Johannes Stezenbach <js@sig21.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 5:35 AM, Johannes Stezenbach <js@sig21.net> wrote:
> On Mon, Oct 25, 2010 at 03:03:57PM -0400, Compat-wireless cronjob account wrote:
>> From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
>>    d9f241e..e10b307  history    -> origin/history
>>  + c8b020e...fd4f9b3 master     -> origin/master  (forced update)
>>    b515316..229aebb  stable     -> origin/stable
>>  * [new tag]         next-20101025 -> next-20101025
> ...
>> Base tree: linux-next.git
>> Base tree version: next-20101025
>> compat-wireless release: compat-wireless-2010-10-22-pc
>
> I wonder about the different tarballs in
> http://wireless.kernel.org/download/compat-wireless-2.6/
>
> compat-wireless-2010-10-25.tar.bz2
> compat-wireless-2010-10-25-p.tar.bz2
> compat-wireless-2010-10-25-pc.tar.bz2
>
> Those -p and -pc postfixes are not explained in
> http://wireless.kernel.org/en/users/Download

Right, sorry, I haven't updated the docs to add documentation for
them. First please read:

http://marc.info/?l=linux-wireless&m=128716953726075&w=2

-s is for getting and applying pending-stable/ fixes
-n is for applying the patches linux-next-cherry-picks directory
-p is for applying the patches on the linux-next-pending directory
-s is for applying the patches on the crap directory

> On a related note, I ran across compat-wireless-2.6.36-rc8-1-cs.tar.bz2 in
> http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.36/
> which is not linked on
> http://wireless.kernel.org/en/users/Download/stable/#Releases

That was sort of an RC release I made that I was waiting on feedback
on for some extra linux-next-pending patch merged but I was still
waiting for one test and no one got back to me yet on that. I'm just
going to go ahead and release a new tarball today.

> and I wonder about the -s and -cs postfixes?

This is the crap and the stable fixes propagated. I only had one crap
patch to incorporate though so I will move that to linux-next-pending
and we'll have at -ps release, which means one linux-next-pending
patch will be applied and we'll also get all pending stable fixes
merged.

> Can someone shed a light on this?

Hope this helps.

  Luis
