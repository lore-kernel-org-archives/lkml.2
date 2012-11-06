Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964802Ab2KFCab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 21:30:31 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54047 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765Ab2KFCa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 21:30:29 -0500
MIME-Version: 1.0
In-Reply-To: <s5hhap49den.wl%tiwai@suse.de>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	<alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
	<20121029174131.GC7580@srcf.ucam.org>
	<s5hobjia6vj.wl%tiwai@suse.de>
	<20121031173728.GA18615@srcf.ucam.org>
	<s5h390utqv3.wl%tiwai@suse.de>
	<1351743715.21227.95.camel@linux-s257.site>
	<20121101131849.752df6fd@pyramind.ukuu.org.uk>
	<s5hip9k9dng.wl%tiwai@suse.de>
	<s5hhap49den.wl%tiwai@suse.de>
Date: Tue, 6 Nov 2012 10:30:26 +0800
Message-ID: <CACVXFVN8qPTgiYKXaeKFJXLXMjLE=+=8Vev2otD3v1VMk+Ez_w@mail.gmail.com>
Subject: Re: [PATCH RFC 0/4] Add firmware signature file check
From: Ming Lei <tom.leiming@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        joeyli <jlee@suse.com>, Jiri Kosina <jkosina@suse.cz>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 1:18 AM, Takashi Iwai <tiwai@suse.de> wrote:
>
> To be noted, it doesn't support the firmwares via udev but only the
> direct loading, and the check for built-in firmware is missing, too.

Generally, both direct loading and udev may request one same firmware
image. And after check failed, current firmware load will fallback on udev
to complete loading, so looks a check-failed firmware still can be loaded
into kernel no matter if there is firmware signature check or not.


Thanks,
--
Ming Lei
