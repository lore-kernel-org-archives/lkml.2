Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab1CQRzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 13:55:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53028 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab1CQRzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 13:55:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: IIO comments
Date: Thu, 17 Mar 2011 18:54:52 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.5.1; x86_64; ; )
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
References: <201103152215.20059.arnd@arndb.de> <201103171603.35700.arnd@arndb.de> <4D823AF8.8070408@cam.ac.uk>
In-Reply-To: <4D823AF8.8070408@cam.ac.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103171854.52777.arnd@arndb.de>
X-Provags-ID: V02:K0:IBKIhNwJnLsg6U6vnOf8oeajKHuEtYEVtXcXNkt/TWJ
 0YBKv2H4p+N4Gi3ohJXsqF9rQOveLuCuzu9YrauqsZqWf8ZKEl
 CbwxumpQCZJlB4Q1Doq7KmkywUsZtEFUfT3mmOmVZ3U3lNSZL9
 gsvU2lH4hLh6HDh7w40Of9fV0Qc1LO3WfoHRJVRrMeDU//FWHm
 vBCGLNbvnETFXQb2bUzNA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 March 2011 17:46:48 Jonathan Cameron wrote:
> > 
> > Since I haven't fully understood the distinction between the
> > three chardevs, it may of course turn out a bad idea, but I
> > think it would simplify the core code if you could assume
> > that every iio device has exactly one chardev interface,
> > so you could give them the same unique number and manage
> > the life time together.
>
> It simplifies that corner, but I'm a little worried that it
> will add a lot of interlinks between the currently fairly
> disconnected elements that go through a character device.
> 
> If we can keep those links to a minimum (which I think
> we can, but haven't tried yet!) it will be a sensible move.

Let's first work out how a single event buffer should work
using read and poll, as discussed in the other thread.
Once we have sorted that out, this may become a lot clearer.

	Arnd
