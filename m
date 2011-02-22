Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab1BVSGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 13:06:24 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39555 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752174Ab1BVSGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 13:06:23 -0500
X-Sasl-enc: cEMyziiJ1ZMOeADq0c5xG1jF5ljgMlJQssHP8YsfGygv 1298397982
Date: Tue, 22 Feb 2011 15:06:11 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Maciej =?utf-8?Q?Kotli=C5=84ski?= <makotlinski@gmail.com>
Cc: Karsten Keil <kkeil@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: e1000e EEPROM corruption
Message-ID: <20110222180611.GA724@khazad-dum.debian.net>
References: <20081017135910.GA18206@pingi.kke.suse.de>
 <4D63CC34.6070807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D63CC34.6070807@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Feb 2011, Maciej Kotliński wrote:
> I had such problem few times earlier but it used to disappear after
> few hours.

Looks like a hardware issue to me. Cold/broken solders (reflowing the board
could fix it), for example.

> I have access to the same laptop, so I can get correct EPROM contents.
> Still I don't know how to put this to my card.
> 
> Could you tell me how to reprogram my card?

That would only help if the problem is a "weak programming" of the EEPROM,
which is something I have never seen before.  Writing to it with flacky
circuitry is probably going to crap it for good.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
