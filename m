Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316Ab0IVEks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 00:40:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60153 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab0IVEks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 00:40:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hPKdQrGzRqsKDVoQtiJlVOQjBI72yaxlwc0c7v0ipEMLPpHWmLkW4v/ULGbZgNj9zO
         CsCDOO55rTxSgVbxg70XTzkPHUE2L0oHoIZeE8rwIuGwpEQTd9pQjDrsTFJjbKAN5XW0
         T8XF0jPS3MuIWf3wbUcQMhyfWWHhKxVXZhO8A=
Message-ID: <4C9988D5.5010700@gmail.com>
Date: Tue, 21 Sep 2010 21:40:53 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Finn Thain <fthain@telegraphics.com.au>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Matt Turner <mattst88@gmail.com>,
        Dimitry Torokhov <dmitry.torokhov@gmail.com>,
        Ben Pfaff <blp@cs.stanford.edu>, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH]Update-broken-web-addresses-in-the-kernel
References: <1285042724-19135-1-git-send-email-justinmattock@gmail.com> <alpine.LNX.2.00.1009211518290.9370@nippy.intranet>
In-Reply-To: <alpine.LNX.2.00.1009211518290.9370@nippy.intranet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > diff --git a/drivers/hwmon/adcxx.c b/drivers/hwmon/adcxx.c
 > index fbdc765..8803ed9 100644
 > --- a/drivers/hwmon/adcxx.c
 > +++ b/drivers/hwmon/adcxx.c
 > @@ -14,7 +14,7 @@
 >   *   and 101 for 1 MSPS)
 >   *
 >   * Complete datasheets are available at National's website here:
 > - * http://www.national.com/ds/DC/ADC<bb><c>S<sss>.pdf
 > + * http://www.national.com/products/catalog.do
 >Wrong. Google this and you will see what I mean.

 >site:www.national.com inurl:ds/DC

looking at this one, I think it might be better to leave alone,
reading the info above the url gives better insight on how they came up 
with: ADC<bb><c>S<sss>.pdf

or I can just use: http://www.national.com/analog/documents/guides
googling does gives results, but the part number is up to the person 
doing the designing etc..(searches are showing nothing with adcxx
just the companies product numbers for their products).

Justin P. Mattock
