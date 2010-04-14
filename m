Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270Ab0DNSNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 14:13:55 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44986 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194Ab0DNSNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 14:13:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hLPhWlbuvqegEyQO+uuzWrz7CMwYB5AStlM4EGTSAZxjBAs8w2v7rRoVxTHAwz6nd+
         hmh/u9r5ErPjlzMxPq1RJl10mbgz29sGINbSnhOCtrL5CjzMwtjAs3xyUnxUszr/pJnv
         aENMtW1WkTM/47UUD3nLuW11MfYIwSG5ZbN4o=
MIME-Version: 1.0
In-Reply-To: <1271231840l.5270l.0l@i-dmzi_al.realan.de>
References: <4BC56F21.6040909@call-direct.com.au>
	 <1271231840l.5270l.0l@i-dmzi_al.realan.de>
Date: Wed, 14 Apr 2010 11:13:52 -0700
Message-ID: <v2u347733d51004141113r670eb5edgf140bdf197724e42@mail.gmail.com>
Subject: Re: [PATCH] Fix Oops with Atmel SPI
From: Kevin Cernekee <cernekee@gmail.com>
To: Anders Larsen <al@alarsen.net>
Cc: Iwo Mergler <iwo@call-direct.com.au>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Ian McDonnell <ian@brightstareng.com>, Nicolas Pitre <nico@fluxnic.net>,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       Matthias Kaehlcke <matthias@kaehlcke.net>,
       David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 12:57 AM, Anders Larsen <al@alarsen.net> wrote:
> the original problem occurs with SPI flashes, which typically have a much
> smaller erase block size (and it only occurs when they are driven by an Atmel
> SoC SPI controller, hence the #ifdefs)

FWIW, the 16MiB Spansion SPI NOR flashes I've been seeing on new
designs have 64KiB or 256KiB (!) eraseblocks.  256KiB eraseblocks are
likely to become even more common as the device capacity increases to
32MiB and beyond.
