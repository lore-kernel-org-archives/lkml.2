Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614Ab0IJGIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 02:08:17 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55341 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756848Ab0IJGIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 02:08:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=KKpeCjVdvWRWLLeAUE81D/nSsvEWkD1uxCQapYQprgmjeWrM81ZSFqmCNIBCI1ikz6
         CZnb3MwJ6nFYpSVgW52AF6jDR2ytHeRKL3TUbx41ZQB0jS0LhZzMV5hrYDRAXNpgCeGB
         rPJygxzndBZ2gyZGahCWOj9KSagKh7kU/npCk=
Message-ID: <4C89CB71.90403@gmail.com>
Date: Thu, 09 Sep 2010 23:08:49 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Norbert Preining <preining@logic.at>
CC: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: Re: after closing the lid and reopening it the screen remains blank
References: <20100909224117.GA30000@gamma.logic.tuwien.ac.at>
In-Reply-To: <20100909224117.GA30000@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2010 03:41 PM, Norbert Preining wrote:
> Hi all,
>
> running: 2.6.36-rc3+ (from git) on Integrated Graphics Chipset: Intel(R) GM45
> (Sony Vaio Z11)
> Debian/unstable, so xserver 1.7.7, intel driver: 2.12.0
>
> since some recent kernel I have the following problem: When closing the
> lid on power, so the machine does not suspend, the backlight is properly
> turned off.
>
> But when I open the lid again the backlight goes on, but there is nothing
> to see: No screensaver, no activity, nothing. Switching to Console in
> blind didn't work either.
>
> The machine is still responsible (Sysrq, but also CapsLock), and
> killing the X process with Ctrl-Alt-Backspace gets me back a working
> X.
>
> I am quite sure that it *was* working in former time, but cannot
> pinpoint eaxactely when the problems started.
>
> If you need any further information or testing, please let me know.
> But it will take some time until I am back somewhere where I can
> ssh into my machine (or try if I can ssh into).
>
> Best wishes
>
> Norbert
> ------------------------------------------------------------------------
> Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
> JAIST, Japan                                 TeX Live&  Debian Developer
> DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
> ------------------------------------------------------------------------
> BELPER
> A knob of someone else's chewing gum which you unexpectedly find your
> hand resting on under a deck's top, under the passenger seat of your
> car or on somebody's thigh under their skirt.
> 			--- Douglas Adams, The Meaning of Liff
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


if you change up kernels and one of them causes this..then I would do a 
bisect.. but if changing kernels makes no diff, then it's userpsace 
related(but could be wrong) i.e. on my machine I use acpid 
/etc/acpi/lid.sh in there its a simple call to s2ram (works fine(with 
radeon though))looking at some of the distros scripts(no-offense) theres 
loads of stuff in there todo all kinds of calls..

hope this helps.

Justin P. Mattock
