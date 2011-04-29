Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933919Ab1D2Vw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 17:52:27 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59732 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760937Ab1D2Vw0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 17:52:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WxUEpclZJEEuE4czW6cdyhMKC/wACZs6N+z35OOQvAmfq2zfouH05g64VZSRdjcYtd
         4qzG7/UHN4Jd5e3sjzO+uaCRVWTrIP+s2ZtI5rBIYpWxDJ7h4xH8gw7im4UojJkPH37R
         AxoDe+/IoZFKI6NSPdOU8UIOOsVDx2hsjlltA=
MIME-Version: 1.0
In-Reply-To: <20110429211548.GA4351@spotteswoode.de.eu.org>
References: <4db8436a.NDzkd3ql2wJdwy2L%Larry.Finger@lwfinger.net>
	<20110428150819.GA3713@spotteswoode.de.eu.org>
	<4DB9884F.10409@lwfinger.net>
	<BANLkTin7Nw1ZjK8UHfypHXY5ZuzafXnJbQ@mail.gmail.com>
	<20110428201527.GA3738@spotteswoode.de.eu.org>
	<BANLkTimi4cUzS5-r_ofzLnjbVtNNjwD69Q@mail.gmail.com>
	<20110429211548.GA4351@spotteswoode.de.eu.org>
Date: Sat, 30 Apr 2011 05:52:23 +0800
Message-ID: <BANLkTi=-4NaMCMEDxj3CVg6iAmS3DGm0Qw@mail.gmail.com>
Subject: Re: [PATCH] staging: r8712u: Fix driver to support ad-hoc mode
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: clemens fischer <ino-news@spotteswoode.dnsalias.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, wlanfae@realtek.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 30, 2011 at 5:15 AM, clemens fischer
<ino-news@spotteswoode.dnsalias.org> wrote:

> I cannot find out what it is:  "dnsmasq(8)" even gives out a lease, the
> firewall doesn't block any packets etc.  Note that "wpa_supplicant(8)"
> could set the ESSID while "iwconfig(8)" couldn't.  I think it has to do
> with my mobile, a window$-mobile-6.1 device, because I cannot see the
> typical log entries:
>
>  client provides name: wince
>  vendor class: Microsoft Windows CE
>  DHCPREQUEST(wlan0) 192.168.3.2 ...
>  DHCPACK(wlan0) 192.168.3.2 ...
>  requested options: 1:netmask, ...

It looks like dhcpd has given you an IP. That's good. Can you try to
ping your mobile from your server. Does ping return anything?

# ping 192.168.3.2


Jeff
