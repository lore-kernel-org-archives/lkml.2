Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab1EICA4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 22:00:56 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40670 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab1EICAz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 22:00:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rCvI88gCnSoJedtbDTpkHuwVgo0GEj8hd3YFy5yl1iNxjmnchGb52nreSd1vWMILJ6
         uAQo9s/2gG+kl1NHmMpKIF3G8KFdR1JaFQFJPy0NhgAH2YyjuGQ+Ipd3dLABGjFZw5Dv
         GxNGXLvdvQlQyHSrSohXoOZ9VCjZT2wuwQqYI=
MIME-Version: 1.0
In-Reply-To: <201105082112.14959.gheskett@wdtv.com>
References: <201105082023.09878.gene.heskett@gmail.com>
	<20110508174528.24b0f0c2.rdunlap@xenotime.net>
	<201105082112.14959.gheskett@wdtv.com>
Date: Sun, 8 May 2011 19:00:54 -0700
Message-ID: <BANLkTik5uTMRpg5mj2MtnW+MZDgWwOgyUQ@mail.gmail.com>
Subject: Re: trying to build 2.6.38.5?
From: Connor H <cmdkhh@gmail.com>
To: gene heskett <gheskett@wdtv.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unable to reproduce using the included config file,

Connor

On Sun, May 8, 2011 at 6:12 PM, gene heskett <gheskett@wdtv.com> wrote:
> On Sunday, May 08, 2011, Randy Dunlap wrote:
>>On Sun, 8 May 2011 20:23:09 -0400 Gene Heskett wrote:
>>> At the end of a make -j2 all:
>>>
>>> /home/gene/src/linux-2.6.38.5-gene/include/linux/Kbuild:25: ***
>>> commands commence before first target.  Stop.
>>> make[2]: *** [linux] Error 2
>>> make[2]: *** Waiting for unfinished jobs....
>>> make[1]: *** [headers_install] Error 2
>>> make: *** [vmlinux] Error 2
>>>
>>> What am I missing?
>>
>>I can't reproduce this problem.  Please post your kernel .config file.
>>
>
> Attached, thanks Randy.
>
> --
> Cheers, Gene
> "There are four boxes to be used in defense of liberty:
>  soap, ballot, jury, and ammo. Please use in that order."
> -Ed Howdershelt (Author)
> <http://tinyurl.com/ddg5bz>
> <http://www.cantrip.org/gatto.html>
> Paranoia is heightened awareness.
>
> --
> Cheers, Gene
> "There are four boxes to be used in defense of liberty:
>  soap, ballot, jury, and ammo. Please use in that order."
> -Ed Howdershelt (Author)
> <http://tinyurl.com/ddg5bz>
> <http://www.cantrip.org/gatto.html>
> All I ask of life is a constant and exaggerated sense of my own importance.
>
