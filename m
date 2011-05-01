Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761353Ab1EATzy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 15:55:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45067 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab1EATzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 15:55:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-pgp-id:x-archive
         :user-agent;
        b=RTEs2JPkFpwmjEXCRbu244BzS8gMAuuEOx4fwVbHHjWI9qR6NuXQg9rcx5fVKLurRZ
         PBSEr6fGOoYbEDlZQfyiZFMRo2pqW/UaB3pK7hkKpRpCLFaLCwQj9fPXRpBPjnF54pDY
         fzeCGxcp2WBWIWe+DloqeSVlAs7YixSX3fka4=
Date: Sun, 1 May 2011 21:55:38 +0200
From: clemens fischer <ino-news@spotteswoode.dnsalias.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, wlanfae@realtek.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: r8712u: Fix driver to support ad-hoc mode
Message-ID: <20110501195537.GB4188@spotteswoode.de.eu.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=zZpZ-qvF8ztvdCf6UtCVfs-ifMw@mail.gmail.com>
X-PGP-ID: 0x214190AF
X-Archive: encrypt=none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Jeff Chua:

> On Mon, May 2, 2011 at 12:40 AM, clemens fischer
>
> >> Jeff Chua:
>
> >> You wish just came true. To use plain iwconfig with wpa_supplicant,
>
> That was my mistake. It should read "To use plain iwconfig _WITHOUT_
> wpa_supplicant" ...

Ahh!  Very good!  Have to try it now... and it works indeed!  This is
nice.  I never tried all combinations in the order of applying sbin/ip
and sbin/iwconfig.  Did you simply try or was the hint burried in the
sources somewhere?

To clarify things:  I needed to make an access-point, but didn't want to
buy proper, ie. supported hardware at this time, so I settled for adhoc.
It works good enough, even if I have to monitor traffic from time to
time for breakins due to weak WEP security.

> >> here's what you need to do ...
> >> just remember that the "order" is important ... you must set the
> >> encryption key "before" you bring up the interface!!! This applies to
> >> non-realtek devices as well.
>
>
> > This was my reason for prefering iwconfig(8) in the first place after
> > realizing that this little USB WLAN stick cannot be used for WPE, only
> > for Ad-hoc with WPA.
>
> huh? WPE ... do you mean WEP?

Sorry.  You're right.  WPE is short for "Want Peppered Encheladas", of
course.

BTW, thanks for taking this topic all through with me, you are a big
help  =8^)


regards, clemens
