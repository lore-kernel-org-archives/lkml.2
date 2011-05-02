Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab1EBFI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 01:08:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60554 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab1EBFIV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 01:08:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=r58cKOAvscBMzqJ7dYHcME4AHLnblEjxn9taA7iAcLKNPKw7XAG4yZdOcyejaxobou
         WrE1ftc7fY9PktvwBjvVNchYggVuYZQMsWVYaXKi2X7RqawXXxknhKbVHk8nUdr7WfiW
         I+r/BFU+w74EU8VsX9Dzqc+PbxDByNZsv2OiU=
MIME-Version: 1.0
In-Reply-To: <20110501195537.GB4188@spotteswoode.de.eu.org>
References: <BANLkTimi4cUzS5-r_ofzLnjbVtNNjwD69Q@mail.gmail.com>
	<20110429211548.GA4351@spotteswoode.de.eu.org>
	<BANLkTi=-4NaMCMEDxj3CVg6iAmS3DGm0Qw@mail.gmail.com>
	<20110429222548.GC4351@spotteswoode.de.eu.org>
	<BANLkTimK-i7aBrFJjGfxQkz-YkLd-ftCnA@mail.gmail.com>
	<20110430014157.GB3719@spotteswoode.de.eu.org>
	<20110430122115.GA3694@spotteswoode.de.eu.org>
	<BANLkTimZ7gFiQyiYpo1SBirBhpkT427o2Q@mail.gmail.com>
	<20110501164013.GA4188@spotteswoode.de.eu.org>
	<BANLkTi=zZpZ-qvF8ztvdCf6UtCVfs-ifMw@mail.gmail.com>
	<20110501195537.GB4188@spotteswoode.de.eu.org>
Date: Mon, 2 May 2011 13:08:19 +0800
Message-ID: <BANLkTi=LyMY2z9Gsepn7KbaX-_+m9XUS3w@mail.gmail.com>
Subject: Re: [PATCH] staging: r8712u: Fix driver to support ad-hoc mode
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: clemens fischer <ino-news@spotteswoode.dnsalias.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, wlanfae@realtek.com,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 2, 2011 at 3:55 AM, clemens fischer
<ino-news@spotteswoode.dnsalias.org> wrote:
>> Jeff Chua:
>
>> On Mon, May 2, 2011 at 12:40 AM, clemens fischer
>>
>> >> Jeff Chua:
>>
>> >> You wish just came true. To use plain iwconfig with wpa_supplicant,
>>
>> That was my mistake. It should read "To use plain iwconfig _WITHOUT_
>> wpa_supplicant" ...
>
> Ahh!  Very good!  Have to try it now... and it works indeed!  This is
> nice.  I never tried all combinations in the order of applying sbin/ip
> and sbin/iwconfig.  Did you simply try or was the hint burried in the
> sources somewhere?

On the intel 4965 and even newer iwlagn module, it's still works the
same ... meaning configuring the wep keys first before bringing up the
interface. There was bug 3 years in the intel 4965 module very similar
to this one. Back the, Thomas and Johannes were kind enough to help
tracing down the bug.

> To clarify things:  I needed to make an access-point, but didn't want to
> buy proper, ie. supported hardware at this time, so I settled for adhoc.
> It works good enough, even if I have to monitor traffic from time to
> time for breakins due to weak WEP security.

Just be careful of the "tiny" usb stick. It's small, very small, so
the signal is also "weak" (30% weaker ... my guess only) compared to
the build-in wireless on my X220 notebook.

Jeff
