Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761236Ab1EARVO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 13:21:14 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49034 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab1EARVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 13:21:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KSNMz77qL3w9x2AGQAvsEmyLm66jetR3TJHR6SUMeLzN4oarY7c2wn2Z6EJl/FUwLf
         3ylcnMscnmd/+IevrXPEVDhNK24bicZsMBtZcXoXNe9mn4bg0qGb49PW5gwHICvbPBep
         txzwc6n/8Po+zVYCfzlcIb645z5eXvUov++/4=
MIME-Version: 1.0
In-Reply-To: <20110501164013.GA4188@spotteswoode.de.eu.org>
References: <BANLkTin7Nw1ZjK8UHfypHXY5ZuzafXnJbQ@mail.gmail.com>
	<20110428201527.GA3738@spotteswoode.de.eu.org>
	<BANLkTimi4cUzS5-r_ofzLnjbVtNNjwD69Q@mail.gmail.com>
	<20110429211548.GA4351@spotteswoode.de.eu.org>
	<BANLkTi=-4NaMCMEDxj3CVg6iAmS3DGm0Qw@mail.gmail.com>
	<20110429222548.GC4351@spotteswoode.de.eu.org>
	<BANLkTimK-i7aBrFJjGfxQkz-YkLd-ftCnA@mail.gmail.com>
	<20110430014157.GB3719@spotteswoode.de.eu.org>
	<20110430122115.GA3694@spotteswoode.de.eu.org>
	<BANLkTimZ7gFiQyiYpo1SBirBhpkT427o2Q@mail.gmail.com>
	<20110501164013.GA4188@spotteswoode.de.eu.org>
Date: Mon, 2 May 2011 01:21:08 +0800
Message-ID: <BANLkTi=zZpZ-qvF8ztvdCf6UtCVfs-ifMw@mail.gmail.com>
Subject: Re: [PATCH] staging: r8712u: Fix driver to support ad-hoc mode
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: clemens fischer <ino-news@spotteswoode.dnsalias.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, wlanfae@realtek.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 2, 2011 at 12:40 AM, clemens fischer
<ino-news@spotteswoode.dnsalias.org> wrote:
>> Jeff Chua:

>> You wish just came true. To use plain iwconfig with wpa_supplicant,

That was my mistake. It should read "To use plain iwconfig _WITHOUT_
wpa_supplicant" ...

>> here's what you need to do ...
>> just remember that the "order" is important ... you must set the
>> encryption key "before" you bring up the interface!!! This applies to
>> non-realtek devices as well.


> This was my reason for prefering iwconfig(8) in the first place after
> realizing that this little USB WLAN stick cannot be used for WPE, only
> for Ad-hoc with WPA.

huh? WPE ... do you mean WEP?

Jeff
