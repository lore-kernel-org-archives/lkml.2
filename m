Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab2FSPCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 11:02:08 -0400
Received: from antcom.de ([188.40.178.216]:55933 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742Ab2FSPCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 11:02:05 -0400
Message-ID: <4FE0946B.8030201@antcom.de>
Date: Tue, 19 Jun 2012 17:02:03 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: dgdunix@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: gpio_keys_polled.c and DT
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

as far as I can see, gpio_keys_polled.c currently doesn't support DT
initialization. Is there a plan in this regard?

Rather than duplicating the respective code from gpio_keys.c, maybe
gpio_keys.c could be changed to support a polled mode also? This way,
gpio_keys_polled.c could be removed.

I could try to do either of those.

Or am I missing sth. here?

Thanks in advance,

Roland
