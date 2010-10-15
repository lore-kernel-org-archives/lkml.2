Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab0JOUQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:16:10 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48599 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183Ab0JOUQI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:16:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Qo7qQ/nm75L/1piy0Xy00PzeyYeQ1GFC6SJU86CAO1x4zv64Fi8nkdj1lPT2ABHPCd
         AeekSTD40u+Km0C0dpTq9dtcznVxfb4Qpu21Mtixfme9Y1W4dLdGOK6lWEU5UDps+mdu
         3tL5OWiVQNL+R/70Ecw/kxn+7UYjzZylhFh2I=
MIME-Version: 1.0
In-Reply-To: <20101015194040.GA20880@kroah.com>
References: <1287144784-3359-1-git-send-email-marek.belisko@gmail.com>
	<1287144784-3359-7-git-send-email-marek.belisko@gmail.com>
	<20101015194040.GA20880@kroah.com>
Date: Fri, 15 Oct 2010 22:16:06 +0200
Message-ID: <AANLkTinWzONzzAd-nSzX1QeiVDS-c91sn44Biz2gtt_i@mail.gmail.com>
Subject: Re: [PATCH 7/7] staging: ft1000: Remove FT1000_INFO typedef usage.
From: Belisko Marek <marek.belisko@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 9:40 PM, Greg KH <greg@kroah.com> wrote:
> On Fri, Oct 15, 2010 at 02:13:04PM +0200, Marek Belisko wrote:
>> Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
>> ---
>>  drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c   |   28 +++++++-------
>>  .../staging/ft1000/ft1000-usb/ft1000_download.c    |   16 ++++----
>>  drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |   42 ++++++++++----------
>>  drivers/staging/ft1000/ft1000-usb/ft1000_proc.c    |   14 +++---
>>  drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |    8 ++--
>>  drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |    6 +-
>>  6 files changed, 57 insertions(+), 57 deletions(-)
>
> Something's wrong with this patch.  There was also something wrong with
> one of the previous ones as well, but I fixed it up by hand.  It seems
> that you forgot to send one of the patches in this series, which caused
> this one to throw a lot of rejects.
>
> Care to resync on my tree to see what I haven't applied from you and
> resend this one, and anything else I've missed?
I forgot to send 1 patch if I check my git logs. I already send it
([PATCH] staging:ft1000: Remove dead code from ft1000_hw.c).

Hopefully it resolved all problems with patch applying.

Sorry.
>
> thanks,
>
> greg k-h
>

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
