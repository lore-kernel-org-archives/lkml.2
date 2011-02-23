Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab1BWWTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 17:19:25 -0500
Received: from smtp-out.google.com ([216.239.44.51]:55950 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab1BWWTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 17:19:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=YFabYM0rePXkRf5hZfKfjjxaOflJ59s3iBsFFxDLmqwDsCws+2PyOE9EEtI5vJ8yYX
         Sb5WoPNnJGeoSqIGYRHw==
Message-ID: <4D6587E6.2080009@google.com>
Date: Wed, 23 Feb 2011 14:19:18 -0800
From: Mike Waychison <mikew@google.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] [PATCH 0/10] Generic Watchdog Timer Driver
References: <20110223204108.GA6327@infomag.iguana.be>
In-Reply-To: <20110223204108.GA6327@infomag.iguana.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/11 12:41, Wim Van Sebroeck wrote:
> Hi All,
>
> To reduce copying the same code over and over in each watchdog device driver, Alan Cox and myself constructed a new framework/API that consolidates the common watchdog timer driver functions.
>
> This framework/API consists of the following patches:
> part  1: Introduction of the WatchDog Timer Driver Core
> part  2: Add the basic ioctl functionality
> part  3: Add the WDIOC_KEEPALIVE ioctl
> part  4: Add the WDIOC_SETOPTIONS ioctl
> part  5: Add the WDIOC_SETTIMEOUT and WDIOC_GETTIMEOUT ioctl
> part  6: Add orphan control
> part  7: Add the Magic Close feature
> part  8: Add the nowayout feature
> part  9: Add support for a miscdev parent device
> part 10: Add support for extra ioctl calls
>
> Note: I still need to add the minimum and maximum timeout parameters.
> (That will become part 11).

Overall, this looks really good IMO.  It goes a long way to setting the 
stage for cleaning up the watchdog drivers themselves :)

Reviewed-by: Mike Waychison <mikew@google.com>
