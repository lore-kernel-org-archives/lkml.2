Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab0GIRuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 13:50:17 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:58652 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751614Ab0GIRuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 13:50:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=VZfxtzy5o4N0bHZPB4kwq0Z/Apry6o3L7++rUEMOXYpjYTgc2K7Lv1Q3lqXAxWy8etBkTCKNvsa8CSAE8af3YeBOqgqvnnugfhvhJ1g+VPWm9+qgXd4MUCDvyTpFq4T7;
Date: Fri, 9 Jul 2010 10:49:53 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Woody Suwalski <terraluna977@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Yet another 2.6.35 regression (AGP)?
Message-ID: <20100709104953.7028c6b7@virtuousgeek.org>
In-Reply-To: <4C374DFF.7050008@gmail.com>
References: <AANLkTikoCiIoo4nfmoFGBMOkc4lNKTU_ouE15EmV1j-h@mail.gmail.com>
	<4C374DFF.7050008@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jul 2010 12:27:43 -0400
Woody Suwalski <terraluna977@gmail.com> wrote:

> Jesse Barnes wrote:
> > On Fri, 9 Jul 2010 10:21:56 -0400
> > Woody Suwalski<terraluna977@gmail.com>  wrote:
> >
> >    
> >> I have found one system, where 2.6.35 does not work (as tested with rc3
> >> and rc4)
> >> That Intel system has no problems in 2.6.33.x nor 2.6.34.0.
> >>
> >> The problem seems to be in AGP - I can boot if I specify "agp=off" - but
> >> of course only in text mode...
> >> There seems to be a hard lock-up, so the only way to show the crash is
> >> by picture 8-)
> >>
> >> Since I do not build kernel on that machine, I did not do any bisect
> >> tests, however if someone is interested in digging deeper, I can try...
> >> Preferably a patch to try out ;-)
> >>
> >> This bug seems to be different then
> >> https://bugzilla.kernel.org/show_bug.cgi?id=16179
> >>
> >> Should it be blamed on BIOS (the conflict indicated just before the crash)?
> >>      
> > Well even if the BIOS is doing something bad, if we handled it in
> > earlier kernels we should handle it today.  So this sounds like a
> > regression.
> >
> > A bisect should help if it was working before, can you do that?
> >
> >    
> OK, I have never really done the brute-force bissecting, but there is 
> always first time...
> Will try to do it over the weekend...

Great, thanks.

> Unless U will be visiting Ottawa  and want to do it yourself ;-)

Nope, no immediate plans. :)

-- 
Jesse Barnes, Intel Open Source Technology Center
