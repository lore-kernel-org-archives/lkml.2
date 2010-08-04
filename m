Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab0HDLsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 07:48:43 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38079 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789Ab0HDLsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 07:48:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SKZGS22gIsDfrlxy0ZDyqsHsJ0KoxAlbQyPhTZ8llJ81yYXvB34kWbuJs23/IiXwEJ
         +dVrTcaWXFzQDJ5yrN9NK37PMTcO+CjMZK9b57QxggXfTuvWHqzX6yAy5fK7hHLE7v65
         bVJ+3fNXnTBO6ESPw811GnvzaH/SzJuUNcqA8=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=8aR=w0j6-XXSCjqCRJkm5X6XRa0rJ=st5YH=r@mail.gmail.com>
References: <1279740179-22451-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTi=8aR=w0j6-XXSCjqCRJkm5X6XRa0rJ=st5YH=r@mail.gmail.com>
Date: Wed, 4 Aug 2010 13:48:41 +0200
Message-ID: <AANLkTiknj+rjddNcXu6esPu7pd=VSLamZWUG4M+YAAZ5@mail.gmail.com>
Subject: Re: [PATCH 2/3] DMAENGINE: add runtime slave config to DMA40 v2
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/3 Dan Williams <dan.j.williams@intel.com>:

> On Wed, Jul 21, 2010 at 12:22 PM, Linus Walleij
> <linus.walleij@stericsson.com> wrote:
>> This extends the DMA engine driver for the DMA40 used in the
>> U8500 platform with the generic runtime slave configuration
>> interface.
>>
>> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
>> ---
>
> What am I missing, this patch does not apply to async_tx.git?

No clue what happened, probably my fault so sent an updated v3.

BTW I saw that Linus pulled Russells tree now so now this -next
clash comes into play with the merge of your tree.

Linus Walleij
