Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab1EGAOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 20:14:08 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39888 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab1EGAOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 20:14:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xG7xBEfGNiJFUQyr6TZ4Ji+VIVBVdldn5PD+pjzdvmNUhFlbXXPyZVOPyngPyaXof+
         qFSePCf4fVncDICv0o8CtSghtVMCRfVZ1g77QDnsNztXIDargV4ioi1mqkoKDDbJaL1e
         INfK5dv3wslk9DQstVmaJ0Qb9S0dE4RA+C/IM=
MIME-Version: 1.0
In-Reply-To: <4DC42897.3000300@slagter.name>
References: <4DC3B0E3.7010008@slagter.name>
	<4DC3D296.9060707@slagter.name>
	<BANLkTimcWN3=qvurDzyMUs8f5+uFPNumaw@mail.gmail.com>
	<4DC42897.3000300@slagter.name>
Date: Sat, 7 May 2011 03:14:05 +0300
Message-ID: <BANLkTinGydyuG58zwVG43VnDz845BOw1Tg@mail.gmail.com>
Subject: Re: OOPS after connection Droids MuIn USB display
From: Maxin John <maxin.john@gmail.com>
To: Erik Slagter <erik@slagter.name>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Erik,

My apologies for misspelling your name in the previous mail.

On Fri, May 6, 2011 at 7:57 PM, Erik Slagter <erik@slagter.name> wrote:
> Yeah, I've found it!
>
> As I mentioned earlier, the device appears to have a control interface and
> no data interface. The current usb cdc-acm code doesn't account for this and
> so yields a oops because data_interface is null.

That's so good to hear.

> I can't give an exact patch because the source is full of added debug
> printk's now ;-)
>
> As far as I understand it, this change results in data_interface to be set
> equal to control_interface and later on this gets dealed with properly.
>
> And now it not only no longer oopses, it actually works!

Congratulations and thanks for explaining the details.

Best Regards,
Maxin
