Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab0FUTEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 15:04:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56988 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757566Ab0FUTEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 15:04:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=uGopt6K3f1++2GVd4gvx1zB/MeZRGyGM/XUt5Of5GUpMkFvp4NfNBSCn7yM9C6P1Fw
         sxIHlWjUUASg7ixKLm2sQ6/Ug90kFspdgObRsAq0I59b13Fd6zke95kwdvSWsDZlYrKK
         u75jkSQoYyV99bnU5rZ4fGltAn7PbUfbicbKk=
MIME-Version: 1.0
Reply-To: linux@schou.dk
In-Reply-To: <1277146250.2501.44.camel@lap75545.ornl.gov>
References: <AANLkTimO5PXmJiIPDw82MTA53mLSl-OC0e1SOEh7v8pH@mail.gmail.com> 
	<1276972298.22889.16.camel@obelisk.thedillows.org> <AANLkTimwZFNLBNJWODyzKXwx9CbIorg3OCA53XZchkeN@mail.gmail.com> 
	<1277043970.22889.45.camel@obelisk.thedillows.org> <AANLkTikBTMq3d-Ov65wYLJ_Vw-7Jde4AOwfXcEPB0wLr@mail.gmail.com> 
	<1277129180.22889.64.camel@obelisk.thedillows.org> <AANLkTikW71h7ABVXY21pLL9AeOlmRTfVaSTjJ_6Ma0_R@mail.gmail.com> 
	<1277146250.2501.44.camel@lap75545.ornl.gov>
From: Hans Schou <linux@schou.dk>
Date: Mon, 21 Jun 2010 21:04:29 +0200
X-Google-Sender-Auth: -c5Zp3ZHOYMJgsSbeJ4K0tFvT4k
Message-ID: <AANLkTin3vbUSxvxHtEQhsjitqwnc4Wal_Gauf7tK5hKV@mail.gmail.com>
Subject: Re: [alsa-devel] PROBLEM: SIS7019 stops recording after 42 min
To: David Dillow <dave@thedillows.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/21 David Dillow <dave@thedillows.org>:
> On Mon, 2010-06-21 at 19:42 +0200, Hans Schou wrote:

>> cmdline is now:
>> arecord -B 250000 -F 125000 -c 1 -r 44100 -f S16 -M -D hw:0,0 -v arec.wav

> This really makes me think the system just cannot keep up. Can you post
> the initial output to verify that it is getting two periods per buffer,
> please?

Then I have to run it again. I do not have it on the screen anymore.
I will do that after the test I'm running now - as mentioned before.

I have turned on my signal generator with 400Hz. I will give it a try
with listen to it, to hear any clicks when the overrun occur.

> Also, does it do the same without the -M ? And you may wish to try
> longer and shorter periods to see if you get so many overruns.

> Also, what storage are you using? Does it support DMA? PIO modes can be
> very slow...

On a daily basis I use USB flash memory stick and have done this more
than a year but always less than 42 min. Right now I'm using old 4GB
external hard disk connected through USB.

/hans
