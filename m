Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab1CFSE2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 13:04:28 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63110 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab1CFSEX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 13:04:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=n1TJU/OxUvQI1ZegtiR5WgDepkOO6ukD8Pr9sHypK+JYYbMkI+/5RrQpcfvkyw2EWa
         FJsTYN6JrZuxn3uluRJzpjt3AG/OiLhi7kF+KkPdClXEquaIKW6hoKd9R654Hayt7Bmf
         y9zdFgtKaLsapiOV2jlR4V+JuaaHXu0Ui50nA=
MIME-Version: 1.0
In-Reply-To: <201103051510.35057.Martin@lichtvoll.de>
References: <201103051510.35057.Martin@lichtvoll.de>
Date: Sun, 6 Mar 2011 13:04:22 -0500
Message-ID: <AANLkTi=3HwdHdQzoLUDebfAAMKwSQvVZ43_eQDfi1iB+@mail.gmail.com>
Subject: Re: [regression] 2.6.37-post-rc7 with radeon kms: reproducably locks
 up hard when using desktop cube of kwin
From: Alex Deucher <alexdeucher@gmail.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: LKML <linux-kernel@vger.kernel.org>, DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 5, 2011 at 9:10 AM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> I will add a regression entry in bugzilla after I got the URL of that
> mail.
>
>
> Hi!
>
> No, I do not actively search for lockup bugs, but they seem to search me
> ;).
>
>
> martin@shambhala:~> cat /proc/version
> Linux version 2.6.38-rc7-tp42-00142-g212e349 (martin@shambhala) (gcc
> version 4.4.5 (Debian 4.4.5-11) ) #4 PREEMPT Sat Mar 5 12:03:41 CET 2011
>
> locks up hard when using desktop cube of kwin from KDE 4.5.1.
>
> It happens within a few seconds to about 30 seconds after activating the
> effect with Ctrl-F11. Otherwise the machine seems to work fine so far - if
> that continues I do not have much of a problem with the bug since I do not
> use desktop cube other than for getting a feel of compositing performance.
> Effects seem to be more fluent, more smooth anyway, I guess due to Radeon
> KMS page flipping.
>
> I am using X.org 1.9.4 with Radeon driver 1:6.14.0-1 on Debian
> Wheezy/Sid/Experimental on a ThinkPad T42 with:
>
> martin@shambhala:~> lspci -nn | grep VGA
> 01:00.0 VGA compatible controller [0300]: ATI Technologies Inc RV350
> [Mobility Radeon 9600 M10] [1002:4e50]
>
> This didn't happen with 2.6.37-tp42-rtime-00004-g9eb63ce, same gcc.

Did you also update your ddx or mesa during this period?  It might
also be a issue in the userspace acceleration drivers.  Are you using
the r300 classic or r300 gallium 3D driver?

Alex

>
> Possibly related to bug #28622 "radeon video lookup".
>
>
> As I am in my holidays in Sevilla I will only care about bisecting when it
> rains three days in a row ;) - cause I insist on my holidays being
> holidays and so will only do light kernel testing ;). I wanted to report
> this nonetheless since at least on my machine this is really easy to
> reproduce.
>
> Ciao,
> --
> Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
> GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
>
