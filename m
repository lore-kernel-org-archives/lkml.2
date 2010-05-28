Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab0E1Kcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 06:32:45 -0400
Received: from www84.your-server.de ([213.133.104.84]:42151 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab0E1Kcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 06:32:43 -0400
Subject: Re: really generic, type save and type definable.
From: Stefani Seibold <stefani@seibold.net>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       andi@firstfloor.org, gregkh@suse.de, alan@lxorguk.ukuu.org.uk,
       tytso@mit.edu, iws@ovro.caltech.edu
In-Reply-To: <4BFF7418.8020607@euromail.se>
References: <1273654167-31067-1-git-send-email-stefani@seibold.net>
	 <4BFF7418.8020607@euromail.se>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 28 May 2010 12:32:27 +0200
Message-ID: <1275042747.23895.5.camel@wall-e.seibold.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 28.05.2010, 09:43 +0200 schrieb Henrik Rydberg:
> stefani@seibold.net wrote:
> [...]
> > The main goal was to provide an API which is very intuitive, save and easy
> > to use. So linux will get now a powerful fifo API which provides all what 
> > a developer needs. This will save in the future a lot of kernel space, since
> > there is no need to write an own implementation. Most of the device driver 
> > developers need a fifo, and also deep kernel development will gain benefit 
> > from this API.
> 
> The meaning of the term "multiple readers" referred to in the header is somewhat
> ambiguous. It could in principle refer to concurrent reading of the same
> position, or concurrent reading from different positions. Imaginably, those
> cases also have different locking behavior.
> 
> What happens if two fifos are initialized with the same memory buffer?
> 

That would be a big nonsense! Tell me a real use case for such kind of
request...

> What about one-to-many and many-to-one cases? The input system and the logging
> facilities could serve as examples where such buffers would be useful.
> 

There is no ne-to-many and many-to-one cases since the API will handle
this. You can not read more data then fit in the fifo, also u can not
write more data the fifo can handle.

Stefani


