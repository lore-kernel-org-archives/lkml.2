Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab1D3MVV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 08:21:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35503 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970Ab1D3MVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 08:21:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-pgp-id:x-archive
         :user-agent;
        b=u17vhyK7BIe+WzOhO2hhjl4NMQIqf6Ez3QwN+l4JUqSHyjUdnkrh+SkX6ztBd4Q4Fq
         tddXNn39Ka9Kc8bgWnnehWwHqcXN0oa7H+sWoiP4oymj0dt3Izu6xsC5xWisEZa9WxNu
         bNJ9h7RS0KOjr1M2zzpQx/youDg3anGK5x9x4=
Date: Sat, 30 Apr 2011 14:21:15 +0200
From: clemens fischer <ino-news@spotteswoode.dnsalias.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, wlanfae@realtek.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: r8712u: Fix driver to support ad-hoc mode
Message-ID: <20110430122115.GA3694@spotteswoode.de.eu.org>
References: <20110428150819.GA3713@spotteswoode.de.eu.org>
 <4DB9884F.10409@lwfinger.net>
 <BANLkTin7Nw1ZjK8UHfypHXY5ZuzafXnJbQ@mail.gmail.com>
 <20110428201527.GA3738@spotteswoode.de.eu.org>
 <BANLkTimi4cUzS5-r_ofzLnjbVtNNjwD69Q@mail.gmail.com>
 <20110429211548.GA4351@spotteswoode.de.eu.org>
 <BANLkTi=-4NaMCMEDxj3CVg6iAmS3DGm0Qw@mail.gmail.com>
 <20110429222548.GC4351@spotteswoode.de.eu.org>
 <BANLkTimK-i7aBrFJjGfxQkz-YkLd-ftCnA@mail.gmail.com>
 <20110430014157.GB3719@spotteswoode.de.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110430014157.GB3719@spotteswoode.de.eu.org>
X-PGP-ID: 0x214190AF
X-Archive: encrypt=none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> clemens fischer:

> > Jeff Chua:
>
> > On Sat, Apr 30, 2011 at 6:25 AM, clemens fischer
> > <ino-news@spotteswoode.dnsalias.org> wrote:
> > > whereas "r8712u" has only DHCP offers in the logs but no ACKs.
> >
> > Are you saying you're seeing dhcpd being offered in the log? Please
> > post the log from the time your mobile starts up the r8712u.
>
> Presently I cannot reproduce this peculiar situation.  The win-CE
> device provides next to nothing regarding helpful logs, but I know
> that it said "connected" at various occasions without any link being
> active.  Also, it seems DHCP leases are not verified, instead the
> remaining lease time being taken for granted.

Whatever I did late in the past night: sleeping ten hours helped a lot!

I can now confirm that "r8712u" works in Ad-hoc mode using
"wpa_supplicant(8)", it gets its IP from DHCP, connects everywhere and
lets me get spam and all that.

I have a couple of fancy scripts overseeing things, much less intrusive
than network-managers, but I disabled parts of them and did everything
manually.

In the end it may well have been the windows-mobile device hanging on to
its (dead) DHCP lease, but without that mobiles logs I won't know.

I still wish "r8712u" would let me use wireless-tools/iwconfig, but
I can live with "wpa_supplicant(8)".

Thanks for your effort, guys!


regards, clemens
