Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934191Ab0EUQwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:52:36 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:55973 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934180Ab0EUQwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:52:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-kmail-transport
         :user-agent:x-kmail-link-message:x-kmail-link-type
         :x-kmail-quoteprefix:x-kmail-signatureactionenabled
         :x-kmail-encryptactionenabled:x-kmail-cryptomessageformat
         :x-kmail-recipients;
        b=WLN+/zF4/xDWZLSBXhiGczxUUBQSGaUYv5hqaJZ5v4sOeZFXvujQJL/Sex1x2TWxo9
         qkFFYli/HYcT5ifQ6YruvRf6SeU5Zyc8z2u5nkvlRJye8EhA40P6A6ZzVy0bkfn++1+m
         /c6in2TTU6HZKnIEKcLj5XLFPDpESFB8QLcwk=
Date: Fri, 21 May 2010 09:52:18 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Ping Cheng <pinglinux@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev3)
Message-ID: <20100521165218.GA26439@core.coreip.homeip.net>
References: <1274457354-5570-1-git-send-email-rydberg@euromail.se>
 <AANLkTikBWzgRmso0oQNXcTxeExdKZORXYbIwK9CcMl85@mail.gmail.com>
 <4BF6B673.1080507@euromail.se>
MIME-Version: 1.0
Content-Type: text/Plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF6B673.1080507@euromail.se>
X-KMail-Transport: Mialhub
User-Agent: KMail/1.13.2 (Linux/2.6.34; KDE/4.4.2; x86_64; ; )
X-KMail-Link-Message: 1147040
X-KMail-Link-Type: reply
X-KMail-QuotePrefix: >
X-KMail-SignatureActionEnabled: false
X-KMail-EncryptActionEnabled: false
X-KMail-CryptoMessageFormat: 15
X-KMail-Recipients: Henrik Rydberg <rydberg@euromail.se>, Ping Cheng
 <pinglinux@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, Mika Kuoppala
 <mika.kuoppala@nokia.com>, Peter Hutterer <peter.hutterer@who-t.net>,
 Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
 Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 May 2010 09:36:03 am Henrik Rydberg wrote:
> Ping Cheng wrote:
> > Hi Henrik,
> > 
> > Thank you for your quick turnaround. Two minor comments in line.
> > 
> > Ping
> 
> Thanks for those, yes, both mistakes. Dmitry, in case you find these last
> versions acceptable, perhaps one could change them manually:
> 
> 1. Patch description: s/SYN_MT_SLOT/ABS_SLOT/

Not ABS_MT_SLOT?

> 2. Test: s/hardware of computed/hardware or computed/
> 
> Thanks,
> Henrik

-- 
Dmitry
