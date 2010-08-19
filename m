Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab0HSTXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 15:23:52 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:51725 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab0HSTXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 15:23:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=ZD/HrIRENfd6Nq5hINpGdz8olZZgaTRp7u1r3LC/kXyoo9yDK2yA7mKD+0O7a13C2U
         j2nswdm0MNCMbQUq9fHgwYjgPEFgUk/Kjae5S5iK8GqtP8/e5oDR3SJA5+GyeAI9H3Dj
         bZ5JsJ2w5UpBuMA2vw8OIHsxEgKUp98uPgMTY=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
In-Reply-To: <alpine.LNX.2.00.1008190939460.1019@pobox.suse.cz>
References: <AANLkTimnC384BMdwJtk1Rp33YnAXr66HJqPvBegOxGmC@mail.gmail.com>
	<201008180325.17816.rjw@sisk.pl>
	<AANLkTimdF_eYurw9k0rQRAzSQ-fZMKsFLupnME_ch1Ru@mail.gmail.com>
	<alpine.LNX.2.00.1008180911180.1019@pobox.suse.cz>
	<AANLkTiki82ZFntH2M6UTyB7+215=4mNmk3SsxiS=CGDH@mail.gmail.com>
	<alpine.LNX.2.00.1008181045110.1019@pobox.suse.cz>
	<AANLkTikPC1CGjNcP2ARf8SJw3HTEBOcdgGnDjx87DERX@mail.gmail.com>
	<AANLkTimSkniqYYWAD29VK6Rt45b_5A84fuK0m0q9EznC@mail.gmail.com>
	<AANLkTikooEGbmLT-UVZ3wb1jAjocT1eO06tZkg+kQefV@mail.gmail.com>
	<alpine.LNX.2.00.1008190939460.1019@pobox.suse.cz>
Date: Thu, 19 Aug 2010 20:23:49 +0100
Message-ID: <AANLkTinYSRNWOXwxwAydthX73Sy2YYsZRQGU0hNjiEsR@mail.gmail.com>
Subject: Re: [REGRESSION, bisected] 2.6.36-rc1 - suspend issues
From: trapDoor <trapdoor6@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Gabriel Craciunescu <osnix0@googlemail.com>,
        Andrea Gelmini <andrea.gelmini@gelma.net>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        arnd@arndb.de, trapDoor <trapdoor6@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 8:40 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 18 Aug 2010, Gabriel Craciunescu wrote:
>
>> > > Andrea, Gabriel
>> > > Would you please check if Jiri's patch solves the problem on your end
>> > > as well? Just to make 100% sure we can close related bugzilla call.
>> >
>> > Well, I made the test, with ~10 cycle hibernation/resume.
>> > Everything seems goes right.
>> >
>>
>> Does work fine here also ..
>
> Thanks everyone for confirming. The fix is now in Linus' tree and thus
> will be in -rc2.
>
> --
> Jiri Kosina
> SUSE Labs, Novell Inc.
>

I saw Linus merged your HID pull request yesterday. I've got it now
and can confirm again that everything works OK.

-- 
Thanks
Tomasz B.
