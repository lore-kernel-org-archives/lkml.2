Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab0E1HoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 03:44:18 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:57965 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754162Ab0E1HoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 03:44:16 -0400
Message-ID: <4BFF7418.8020607@euromail.se>
Date: Fri, 28 May 2010 09:43:20 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: stefani@seibold.net
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       andi@firstfloor.org, gregkh@suse.de, alan@lxorguk.ukuu.org.uk,
       tytso@mit.edu, iws@ovro.caltech.edu
Subject: Re: really generic, type save and type definable.
References: <1273654167-31067-1-git-send-email-stefani@seibold.net>
In-Reply-To: <1273654167-31067-1-git-send-email-stefani@seibold.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OHuE5-0005zJ-A9.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1OHuE5-0005zJ-A9 69cada89f23545fb43b2177fc7e5f8ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stefani@seibold.net wrote:
[...]
> The main goal was to provide an API which is very intuitive, save and easy
> to use. So linux will get now a powerful fifo API which provides all what 
> a developer needs. This will save in the future a lot of kernel space, since
> there is no need to write an own implementation. Most of the device driver 
> developers need a fifo, and also deep kernel development will gain benefit 
> from this API.

The meaning of the term "multiple readers" referred to in the header is somewhat
ambiguous. It could in principle refer to concurrent reading of the same
position, or concurrent reading from different positions. Imaginably, those
cases also have different locking behavior.

What happens if two fifos are initialized with the same memory buffer?

What about one-to-many and many-to-one cases? The input system and the logging
facilities could serve as examples where such buffers would be useful.

Henrik

