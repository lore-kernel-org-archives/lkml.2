Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933284Ab1CWXTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 19:19:24 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:50052 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933213Ab1CWXTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 19:19:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=hNw7YsaXK6HIDXdMD+J59BquT4+pq0F/vpLiIuhjAyczpkrD5t9v7GwP6roVweD2hkK4bKY4OlsGuZFjKe2LF+mHx6gSIILOrUZzsDErLCrcLRtdSPd9Tla07ZdN9n5s;
Date: Wed, 23 Mar 2011 16:19:17 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Michal Nazarewicz <mnazarewicz@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, broonie@opensource.wolfsonmicro.com,
        lkml <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Greg KH <greg@kroah.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, grant.likely@secretlab.ca,
        Linux USB list <linux-usb@vger.kernel.org>, andy.green@linaro.org,
        netdev@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        roger.quadros@nokia.com, Jaswinder Singh <jaswinder.singh@linaro.org>
Subject: Re: [RFC] usbnet: use eth%d name for known ethernet devices
Message-Id: <20110323161917.85d2660d.rdunlap@xenotime.net>
In-Reply-To: <8762r9l94h.fsf@erwin.mina86.com>
References: <4D79F068.2080009@linaro.org>
	<201103232035.18232.arnd@arndb.de>
	<AANLkTim7hPfTv3gDYnh+jGxHBg0OvX=r1FKYoHnH7H_o@mail.gmail.com>
	<201103232057.18150.arnd@arndb.de>
	<20110323125958.76285c0f.rdunlap@xenotime.net>
	<8762r9l94h.fsf@erwin.mina86.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 173.50.240.230 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011 00:17:34 +0100 Michal Nazarewicz wrote:

> >>>>>> @@ -97,6 +97,8 @@ struct driver_info {
> >>>>>>
> >>>>>>  #define FLAG_LINK_INTR       0x0800          /* updates link (carrier) status */
> >>>>>>
> >>>>>> +#define FLAG_PTP     0x1000          /* maybe use "usb%d" names */
> 
> >>>> On Wednesday 23 March 2011 19:46:50 Greg KH wrote:
> >>>>> "PTP"?  What does that stand for?
> 
> >>> On Mar 23, 2011 8:36 PM, "Arnd Bergmann" <arnd@arndb.de> wrote:
> >>>> point-to-point, I'll improve the comment to spell it out when
> >>>> I send the fixed version.
> 
> >> On Wednesday 23 March 2011 20:53:13 Michał Nazarewicz wrote:
> >>> I think P2P could be better.
> 
> > On Wed, 23 Mar 2011 20:57:18 +0100 Arnd Bergmann wrote:
> >> Yes, good idea.
> 
> Randy Dunlap <rdunlap@xenotime.net> writes:
> > that's peer-to-peer.
> >
> > OTOH, I knew that PTP was point-to-point.
> 
> It can be any of that, depending on context.  For me PTP is more like
> Picture Transport Protocol, whereas "2" between two letters is usually
> "to".
> 
> Just my two cents though, no strong feelings or anything.

Agreed.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
