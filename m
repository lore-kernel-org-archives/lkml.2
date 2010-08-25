Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab0HYGuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 02:50:25 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42159 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab0HYGuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 02:50:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=d/Zn8BF3zL2NjFvVhp+tjXjvgrfsNIA1sFqzeKLBFNKdML2LD14mCY/cNw/rod3xjh
         vrpf56/i3pSQAmlKSGXg/hevahPKt0xdzHriOMKqvdvWaMugc6ufsy9W90kUCSq8Qsic
         /+oYTys8IDL4EDSkAQEn4DquApEt8V4sP+E4U=
MIME-Version: 1.0
In-Reply-To: <20100825004134.GA28884@suse.de>
References: <20100625120329.1303aa61@lxorguk.ukuu.org.uk>
	<1282683470.8020.66.camel@itpsd6lap>
	<20100824211016.GA7176@suse.de>
	<1282687797.8020.108.camel@itpsd6lap>
	<20100824222035.GA10625@suse.de>
	<1282690232.8020.116.camel@itpsd6lap>
	<20100824225703.GA5913@suse.de>
	<20100825002221.68fc09a4@lxorguk.ukuu.org.uk>
	<20100824231241.GA6971@suse.de>
	<20100825005152.40ba2f12@lxorguk.ukuu.org.uk>
	<20100825004134.GA28884@suse.de>
Date: Wed, 25 Aug 2010 08:50:22 +0200
Message-ID: <AANLkTi=XwRD-oTfe7_qMEjAaupci+ch=AD8iVpok99Mi@mail.gmail.com>
Subject: Re: [PATCH] detour TTY driver - now ttyprintk
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Samo Pogacnik <samo_pogacnik@t-2.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Kay Sievers <kay.sievers@vrfy.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/25 Greg KH <gregkh@suse.de>:
> On Wed, Aug 25, 2010 at 12:51:52AM +0100, Alan Cox wrote:
>
> Seriously, look at how Fedora 14 handles this, why can't you do the same
> for embedded systems all from userspace, no additional code needed
> anywhere.
>
> thanks,
>
> greg k-h
> --

Samo sometimes ago I gave you some information on the system startup
about OpenSuse, have you look at it? It's possible that what Greg
said, it's true.

Regards,

Marco
