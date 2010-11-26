Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab0KZQql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 11:46:41 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60348 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab0KZQqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 11:46:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=UvXIbzTZh50bJPEaYr4w3spNsIvgW92mmsLaKgb9N8Yn4WfWYsAwDYHwkPTw724LAY
         wdGWrXg3u62tf97v+akIovaGWFY+ZDUvNkTbHefOliVTRl8c06BD6DNmJT5CB8AvGyht
         aMF0yfnt5Njmwma/eEzXyVU9LVU9dTdta2I2A=
MIME-Version: 1.0
In-Reply-To: <20101124105126.8248fc1f.randy.dunlap@oracle.com>
References: <201011240045.oAO0jYQ5016010@imap1.linux-foundation.org>
	<20101124105126.8248fc1f.randy.dunlap@oracle.com>
Date: Fri, 26 Nov 2010 16:46:38 +0000
X-Google-Sender-Auth: dpILRJFp83TNy4GMarGFEvj5lEg
Message-ID: <AANLkTik8G7ZQ5Dujcf0rKsctMLqsJUPPQQ+wMJ1Wxbon@mail.gmail.com>
Subject: Re: mmotm 2010-11-23-16-12 uploaded (olpc)
From: Daniel Drake <dsd@laptop.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, Andres Salomon <dilinger@debian.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 November 2010 18:51, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> make[4]: *** No rule to make target `arch/x86/platform/olpc/olpc-xo1-wakeup.c', needed by `arch/x86/platform/olpc/olpc-xo1-wakeup.o'.
>
>
> It's olpc-xo1-wakeup.S, so I guess it needs a special makefile rule ??

Works if you build it in, but fails as above as a module.

And it looks like making it work as a module is not as easy as we
thought. I'll discuss this with Andres and get a new patch submitted
soon.

Daniel
