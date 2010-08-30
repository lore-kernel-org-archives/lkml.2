Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab0H3MQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 08:16:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65382 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449Ab0H3MQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 08:16:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC 0/5] tty: move stuff around
Date: Mon, 30 Aug 2010 14:15:56 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
References: <1283115995-4734-1-git-send-email-arnd@arndb.de> <201008301337.27672.arnd@arndb.de> <4C7B9C1D.9030207@suse.cz>
In-Reply-To: <4C7B9C1D.9030207@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008301415.56934.arnd@arndb.de>
X-Provags-ID: V02:K0:ze+9rVEnqPTwP5mvxVg1lClzi5yU8ZCoTftdPb4FjwW
 +l2Awg7nO2sv2+M4csgxUhw0XQIFtt1cK+YY+kFxhJPzNGifzy
 ZFRRHSqygQxQ2jZttMFzK7HAABsNROhzqaBqSTa9i5bqg6E7Hf
 dryVbNxXcYHjaj5SINwYagfyC6DzHLv1qa3lJ6vdKA/EomKQ0T
 RUbEHcOKH61ONQ5Az3gUw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 August 2010, Jiri Slaby wrote:
> On 08/30/2010 01:37 PM, Arnd Bergmann wrote:
> > These are the drivers I was planning to move:
> > +obj-$(CONFIG_CYCLADES)         += cyclades.o
> 
> There are some users still with CYY cards. No CYZ card users known to me.
> 
> > +obj-$(CONFIG_MOXA_INTELLIO)    += moxa.o
> 
> Maybe few users left.
> 
> > +obj-$(CONFIG_MOXA_SMARTIO)     += mxser.o
> 
> Still in use. (And supports relatively new devices; not the PCI-e ones
> though.)

Are they all candidates for a conversion to serial_core then?
Or are they not sufficiently 8250-like?

	Arnd
