Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab0KRInE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 03:43:04 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35842 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab0KRInD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 03:43:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Scmtdmy++6YjY2c3u6GeoAwGB7geOUj/gmgDgo/Lo3Bt3l+r8c0NhYCNdj7dCle4Gd
         W4dpCU5nh2F1Ydv63UNLFEAiiqtJxD2ImElt6/GAKooZE2590ptQYGZGpfXlw1zjdXY/
         jXf3zo0yMo0y3JkdKCWm3wjPNvdh+o5Cy6jSU=
MIME-Version: 1.0
In-Reply-To: <20101116193646.GB12492@kroah.com>
References: <1289384128-19823-1-git-send-email-marek.belisko@gmail.com>
	<1289384128-19823-2-git-send-email-marek.belisko@gmail.com>
	<20101111002651.GA21632@kroah.com>
	<AANLkTimteY1P_gU5+ArA8xg3FzS0m9kdQygXSptvhGuh@mail.gmail.com>
	<20101116193646.GB12492@kroah.com>
Date: Thu, 18 Nov 2010 09:43:00 +0100
Message-ID: <AANLkTinEvAXRGdgoWfzRx3Q8xSfkuTLhn21AoV3iz0ih@mail.gmail.com>
Subject: Re: [PATCH 2/3] staging: ft1000: Remove unused char dev inerface.
From: Belisko Marek <marek.belisko@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Tue, Nov 16, 2010 at 8:36 PM, Greg KH <greg@kroah.com> wrote:
> On Sat, Nov 13, 2010 at 08:05:40PM +0100, Belisko Marek wrote:
>> Hi Greg,
>>
>> On Thu, Nov 11, 2010 at 1:26 AM, Greg KH <greg@kroah.com> wrote:
>> > On Wed, Nov 10, 2010 at 11:15:27AM +0100, Marek Belisko wrote:
>> >> This patch remove lot of code for character device. This
>> >> interface was used for getting network informations and
>> >> statistics which is currently exported via /proc filesystem.
>> >>
>> >> Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
>> >
>> > This patch does not apply :(
>> I'm trying to resend but need to wait till linux-next will sync with
>> linus kernel.
>> In mainline there is a patch (61241d97db02559bd83d21ffa783ab327945b925) which
>> is not in linux-next.
>>
>> I try to apply patch for mainline but it failed. I'll fix and resend then.
>> Hopefully this is correct if not forgive me ;)
>
> Everything should be synced up now, please resync and resend.
I'll change my mind and from this patch series I'll resend just 1/3 patch.
Patch 2/3 (followed by 3/3) is maybe not correct because it completely
remove access to
device from user space through /dev interface (used for debugging and testing).

My first idea was just remove it completely because we have a device which just
connect to network and don't need to have some debug interface.

Anyway I'll change creation of device in kernel via kernel threads
which is not from my
point of view correct.

>
> thanks,
>
> greg k-h
>

thanks,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
