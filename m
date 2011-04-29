Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933991Ab1D2WZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:25:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43380 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485Ab1D2WZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:25:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:x-pgp-id:x-archive:user-agent;
        b=KRP8EW2Fip/DuCqKz3T0QTeNWTUm+YBfS5sXxs7vpS/Z1nA2NMmG/YF2P5tSQSFjp0
         IqJcPB22+91daKPKjEKSxU01zf4DB1m2JkJVCvnintK3x7ivH4jF8Hl/9jsTUOOFB04g
         nA65HLv3RK1JSktLphe0mhd/LS3T9JmvESVAA=
Date: Sat, 30 Apr 2011 00:25:48 +0200
From: clemens fischer <ino-news@spotteswoode.dnsalias.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, wlanfae@realtek.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: r8712u: Fix driver to support ad-hoc mode
Message-ID: <20110429222548.GC4351@spotteswoode.de.eu.org>
References: <4db8436a.NDzkd3ql2wJdwy2L%Larry.Finger@lwfinger.net>
 <20110428150819.GA3713@spotteswoode.de.eu.org>
 <4DB9884F.10409@lwfinger.net>
 <BANLkTin7Nw1ZjK8UHfypHXY5ZuzafXnJbQ@mail.gmail.com>
 <20110428201527.GA3738@spotteswoode.de.eu.org>
 <BANLkTimi4cUzS5-r_ofzLnjbVtNNjwD69Q@mail.gmail.com>
 <20110429211548.GA4351@spotteswoode.de.eu.org>
 <BANLkTi=-4NaMCMEDxj3CVg6iAmS3DGm0Qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=-4NaMCMEDxj3CVg6iAmS3DGm0Qw@mail.gmail.com>
X-PGP-ID: 0x214190AF
X-Archive: encrypt=none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Jeff Chua:

> On Sat, Apr 30, 2011 at 5:15 AM, clemens fischer
> <ino-news@spotteswoode.dnsalias.org> wrote:
>
> > I cannot find out what it is:  "dnsmasq(8)" even gives out a lease, the
> > firewall doesn't block any packets etc.  Note that "wpa_supplicant(8)"
> > could set the ESSID while "iwconfig(8)" couldn't.  I think it has to do
> > with my mobile, a window$-mobile-6.1 device, because I cannot see the
> > typical log entries:
> >
> >  client provides name: wince
> >  vendor class: Microsoft Windows CE
> >  DHCPREQUEST(wlan0) 192.168.3.2 ...
> >  DHCPACK(wlan0) 192.168.3.2 ...
> >  requested options: 1:netmask, ...
>
> It looks like dhcpd has given you an IP. That's good. Can you try to
> ping your mobile from your server. Does ping return anything?
>
> # ping 192.168.3.2

You misunderstood: The log entries shown were from the configuration
using the old driver whereas "r8712u" has only DHCP offers in the logs
but no ACKs.  But since you asked, "ping(8)" returns:

  From 192.168.3.1 icmp_seq=8 Destination Host Unreachable

192.168.3.1 is the IP of the wlan0 interface of the linux host acting
as the router/DNS-resolver/DHCP-provider.


regards, clemens
