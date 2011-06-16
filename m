Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab1FPHHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:07:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53988 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab1FPHHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:07:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=eHIAG+0IK2VHgsU2xvLvwQrKeAqAylI+sYwit7jvQJtaOVLzJWjpqog/h62mXxrHYT
         UrWNBVAGtDFqJPQ2hE/Tz2jHNWdujT1eKfvKr79keXs25QcBAoVr6kqUPbKezcE7QgjP
         IBDhkXlZvEL4cGjYGat/Z/6Tv0DOv2Ng/Nq9s=
Message-ID: <4DF9AB93.1040903@gmail.com>
Date: Thu, 16 Jun 2011 09:06:59 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110531 Thunderbird/5.0b1
MIME-Version: 1.0
To: Hans Petter Selasky <hselasky@c2i.net>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: DVB_NET help message is useless
X-Enigmail-Version: 1.2a2pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've just updated to 3.0-rc and saw CONFIG_DVB_NET. Hmm, let's see
what's that by asking with '?'. And I got this crap:
================
CONFIG_DVB_NET:

The DVB network support in the DVB core can
optionally be disabled if this
option is set to N.

If unsure say Y.
================
Why do you think this help message is useful? It's clear to
everybody that if one eventually disables it it will be disabled. The
help message should mention _what_ the network support is.

I would send a patch, but I really have no idea what's that good for.

thanks,
-- 
js
