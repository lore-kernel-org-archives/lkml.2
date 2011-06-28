Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab1F1ToS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 15:44:18 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:52527 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752772Ab1F1ToN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 15:44:13 -0400
X-Sasl-enc: Tp+PuF+mzCMY5CxX848Xgh0fdnZg7H425KyZUcnwNXsT 1309290252
Date: Tue, 28 Jun 2011 16:44:09 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Sandy Harris <sandyinchina@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: random(4) driver questions
Message-ID: <20110628194409.GB25840@khazad-dum.debian.net>
References: <BANLkTinC7vfaRWf5TK9gJuQVtVwDkEQFcQ@mail.gmail.com>
 <20110627145442.GA2729@thunk.org>
 <sig.11608c07e8.4E095C34.1020904@containermaster-cmp.de>
 <BANLkTi=X0wu8MpRZh21MzMeeDh81CFHH_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=X0wu8MpRZh21MzMeeDh81CFHH_w@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jun 2011, Sandy Harris wrote:
> Johann Meier <recv@containermaster-cmp.de> wrote:
> > If you don't have a hardware rnd, you can use an entropy daemon like
> > haveged (http://www.issihosts.com/haveged/)
> 
> Yes, and there are several other alternatives. Someone suggested a

The best of which is probably to _get_ a TRNG device.

I can recommend this excellent and inexpensive (< £40) one:
http://www.entropykey.co.uk/

It will do ~32kbit/s (well, at least that's what mine is doing right now).
It is designed for Linux and also for safe use and safe distribution of
entropy.  It is a small USB device, and uses the USB cdc_acm driver to talk
to a FLOSS userspace application (MIT license).

As any USB device, it is _not_ going to be capable of providing entropy to
the kernel boot process or to very early userspace.

PS: I am in no way affiliated with Simtec electronics, I am just one of
their happy customers.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
