Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab1CYMvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 08:51:06 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43506 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab1CYMvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 08:51:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UHetsHGvjEPOCOC6MKaH/Tp/XWDtuRBUr5Izfg2D1dW9f55IBNM5hNn2XaX7dmWTZx
         3xCwtUxw/Tb6oPXDvjQk3Br1aHaQ4WSpRp4eMg7/6aMup8vfliEhOF7clTApGnt2jOwZ
         H238r6ic1q5VcIWDO1md5q/prm1zY4XKbgpKY=
MIME-Version: 1.0
In-Reply-To: <AANLkTim4jYfAFHkaHAWRU2uAzgRJLP1p1=5dugZgYkhS@mail.gmail.com>
References: <alpine.DEB.2.00.1103230417270.29019@skynet.skynet.ie>
	<1300864998.3522.71.camel@thor.local>
	<AANLkTimg4n3Bb=XQYCPLGcCrC5NEQWjfzn-RHu2ZfW=h@mail.gmail.com>
	<1300868532.3522.81.camel@thor.local>
	<AANLkTik1HCrAus2Rv29EK_vGDf9d2m0E=cAuvF6LEQiQ@mail.gmail.com>
	<AANLkTim4jYfAFHkaHAWRU2uAzgRJLP1p1=5dugZgYkhS@mail.gmail.com>
Date: Fri, 25 Mar 2011 09:51:01 -0300
Message-ID: <AANLkTimBFe0zTTMZJz2Qppae59U2qCK3EUXS=RgdVNX6@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Kevin Winchester <kjwinchester@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 March 2011 04:21, Dave Airlie <airlied@gmail.com> wrote:
> I'm also aware we never get enough testing coverage before stuff hits
> your tree, we'd need 1000s of testers to run drm-next and we just
> don't have that variation. So yes when new features hit -rc1 with the
> drm they nearly always cause regressions, its just not possible to
> test this stuff on every GPU/monitor/bios combination in existance
> before we give it to you, that just isn't happening. Like radeon
> pageflipping caused machines to completely hang and I didn't find out
> until -rc7 due to lack of testing coverage.
>

Not that I have much credibility to be talking here, but as a nouveau
user with a problem setup where I cannot seem to find anyone to help
[1], I wonder if getting support for the absolute latest GPUs into
mainline perhaps should not be the highest priority.  Also, have you
considered the possibility that taking longer for code to hit Linus'
tree would have the effect of increasing your tester base for
drm-next?  If I had a new video card that was giving me a blank
screen, I would certainly be ready to try a testing kernel tree if I
thought it would get me some level of functionality.

-- 
Kevin Winchester

[1] https://bugs.freedesktop.org/show_bug.cgi?id=31780
Luckily my problem is not a showstopper, and mainly prevents me from
using my second screen, but creating that bug and posting to the
nouveau mailing list did not get me much help in actually fixing the
problem.  This is despite the fact that I was quite willing to try the
nouveau kernel tree, which unfortunately did not help.
