Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639Ab0GIP6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 11:58:53 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:50496 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757244Ab0GIP6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 11:58:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=d2VG13Xzn9O9dEBw00fuiCCvpXLKGd26rqS5vwsL1J9mcKruHaHJco2Vy0JE26vPh9f6HoMpHXF53ghNlFZikfS45s64vM6pUg8AU5uFEluvYMj2IDysoXow5caJMd3K;
Date: Fri, 9 Jul 2010 08:58:31 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Woody Suwalski <terraluna977@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       drivers_video-dri-intel@kernel-bugs.osdl.org
Subject: Re: Yet another 2.6.35 regression (AGP)?
Message-ID: <20100709085831.758d9ee9@virtuousgeek.org>
In-Reply-To: <4C373084.8000503@gmail.com>
References: <AANLkTikoCiIoo4nfmoFGBMOkc4lNKTU_ouE15EmV1j-h@mail.gmail.com>
	<4C373084.8000503@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jul 2010 10:21:56 -0400
Woody Suwalski <terraluna977@gmail.com> wrote:

> I have found one system, where 2.6.35 does not work (as tested with rc3 
> and rc4)
> That Intel system has no problems in 2.6.33.x nor 2.6.34.0.
> 
> The problem seems to be in AGP - I can boot if I specify "agp=off" - but 
> of course only in text mode...
> There seems to be a hard lock-up, so the only way to show the crash is 
> by picture 8-)
> 
> Since I do not build kernel on that machine, I did not do any bisect 
> tests, however if someone is interested in digging deeper, I can try... 
> Preferably a patch to try out ;-)
> 
> This bug seems to be different then 
> https://bugzilla.kernel.org/show_bug.cgi?id=16179
> 
> Should it be blamed on BIOS (the conflict indicated just before the crash)?

Well even if the BIOS is doing something bad, if we handled it in
earlier kernels we should handle it today.  So this sounds like a
regression.

A bisect should help if it was working before, can you do that?

-- 
Jesse Barnes, Intel Open Source Technology Center
