Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018Ab1CWT5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 15:57:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58575 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932926Ab1CWT5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 15:57:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?Micha=C5=82_Nazarewicz?= <mnazarewicz@gmail.com>
Subject: Re: [RFC] usbnet: use eth%d name for known ethernet devices
Date: Wed, 23 Mar 2011 20:57:18 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38+; KDE/4.5.1; x86_64; ; )
Cc: broonie@opensource.wolfsonmicro.com, lkml <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Greg KH <greg@kroah.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, grant.likely@secretlab.ca,
        Linux USB list <linux-usb@vger.kernel.org>, andy.green@linaro.org,
        netdev@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        roger.quadros@nokia.com, Jaswinder Singh <jaswinder.singh@linaro.org>
References: <4D79F068.2080009@linaro.org> <201103232035.18232.arnd@arndb.de> <AANLkTim7hPfTv3gDYnh+jGxHBg0OvX=r1FKYoHnH7H_o@mail.gmail.com>
In-Reply-To: <AANLkTim7hPfTv3gDYnh+jGxHBg0OvX=r1FKYoHnH7H_o@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201103232057.18150.arnd@arndb.de>
X-Provags-ID: V02:K0:RSQHgUQkoRXzvrBwsfUoSn6mE2aOsliVEgyjOckPA51
 WUuKTsXIF/limm63ZSvoYtgIlO69CPR65jPOE3dFKZieNyemvM
 LVXfUdDeyTMCWlnmPfkFF7cM2nQ5wQpRA3j3KM6oYmqmNW9ops
 heT7c/J03QY5V+tB2eqNlT/bRBVfwqVf97rQu6JyXnn01U97f4
 evdAZXdHDpEa2g+33hcRQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 March 2011 20:53:13 Michał Nazarewicz wrote:
> On Mar 23, 2011 8:36 PM, "Arnd Bergmann" <arnd@arndb.de> wrote:
>  >
>  > On Wednesday 23 March 2011 19:46:50 Greg KH wrote:
>  > > > @@ -97,6 +97,8 @@ struct driver_info {
>  > > >
>  > > >  #define FLAG_LINK_INTR       0x0800          /* updates link (carrier) status */
>  > > >
>  > > > +#define FLAG_PTP     0x1000          /* maybe use "usb%d" names */
>  > >
>  > > "PTP"?  What does that stand for?
>  >
>  > point-to-point, I'll improve the comment to spell it out when I send the
>  > fixed version.
>  
> I think P2P could be better.

Yes, good idea.

	Arnd
