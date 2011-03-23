Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015Ab1CWUAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 16:00:04 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:56323 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932839Ab1CWUAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 16:00:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=BRtdCf9YNG1SCUAG7QFhzciMJxM8WWXKsemMNjCFKPAWfboLdYn0yCuqa/wuPtUexxuMDo6xkLwAitSBiSDwDuRSq5hI/Rnfmg5VawJ+vkF9/PbHEpKV0oQhNwv5B6qE;
Date: Wed, 23 Mar 2011 12:59:58 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: =?UTF-8?B?TWljaGHFgg==?= Nazarewicz <mnazarewicz@gmail.com>,
        broonie@opensource.wolfsonmicro.com,
        lkml <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Greg KH <greg@kroah.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, grant.likely@secretlab.ca,
        Linux USB list <linux-usb@vger.kernel.org>, andy.green@linaro.org,
        netdev@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        roger.quadros@nokia.com, Jaswinder Singh <jaswinder.singh@linaro.org>
Subject: Re: [RFC] usbnet: use eth%d name for known ethernet devices
Message-Id: <20110323125958.76285c0f.rdunlap@xenotime.net>
In-Reply-To: <201103232057.18150.arnd@arndb.de>
References: <4D79F068.2080009@linaro.org>
	<201103232035.18232.arnd@arndb.de>
	<AANLkTim7hPfTv3gDYnh+jGxHBg0OvX=r1FKYoHnH7H_o@mail.gmail.com>
	<201103232057.18150.arnd@arndb.de>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 173.50.240.230 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Mar 2011 20:57:18 +0100 Arnd Bergmann wrote:

> On Wednesday 23 March 2011 20:53:13 Michał Nazarewicz wrote:
> > On Mar 23, 2011 8:36 PM, "Arnd Bergmann" <arnd@arndb.de> wrote:
> >  >
> >  > On Wednesday 23 March 2011 19:46:50 Greg KH wrote:
> >  > > > @@ -97,6 +97,8 @@ struct driver_info {
> >  > > >
> >  > > >  #define FLAG_LINK_INTR       0x0800          /* updates link (carrier) status */
> >  > > >
> >  > > > +#define FLAG_PTP     0x1000          /* maybe use "usb%d" names */
> >  > >
> >  > > "PTP"?  What does that stand for?
> >  >
> >  > point-to-point, I'll improve the comment to spell it out when I send the
> >  > fixed version.
> >  
> > I think P2P could be better.
> 
> Yes, good idea.

that's peer-to-peer.

OTOH, I knew that PTP was point-to-point.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
