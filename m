Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab0EOWId (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 18:08:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48484 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab0EOWIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 18:08:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=iLVaYD97jBa1j9tmd4Mv17ekl22v6V5/KCkbn9IeV4xtRBlOaavwdhcezLK2NQPW+B
         ai7/1sEGgqasiaLQ3ZFzM92S24bFRiGKvU7H5xcMQjWZFZ+h6ODrEZ94VG9WXkzZ7WVA
         kaQPIzX1SrgQ2kDdupeydd1I7XmEqBgB9asHs=
MIME-Version: 1.0
In-Reply-To: <201005152355.54762.oliver@neukum.org>
References: <1273959602-15465-1-git-send-email-abogani@texware.it>
	 <201005152355.54762.oliver@neukum.org>
Date: Sun, 16 May 2010 00:08:30 +0200
X-Google-Sender-Auth: w7yeKMY_XQVD1QRi8ulrFxNTYbE
Message-ID: <AANLkTilSP7AYz08-aTNJ1fWCYrgbTebJznAIps1AbjoW@mail.gmail.com>
Subject: Re: [PATCH] Staging: quatech_usb2: Convert eos semaphore to mutex
From: Alessio Igor Bogani <abogani@texware.it>
To: Oliver Neukum <oliver@neukum.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Bill Pemberton <wfp5p@virginia.edu>, Jiri Kosina <jkosina@suse.cz>,
       Javier Martinez Canillas <martinez.javier@gmail.com>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

2010/5/15 Oliver Neukum <oliver@neukum.org>:
> Am Samstag, 15. Mai 2010 23:40:02 schrieb Alessio Igor Bogani:
>> The eos semaphore is used as a mutex so replace it with a real mutex.
>
> Documentation/mutex-design.txt states that a mutex must not be used
> from within an interrupt handler. Is this outdated?

You are right. Simply I didn't see irqreturn_t return type in function
prototype.

Sorry for my mistake.

Ciao,
Alessio
