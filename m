Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab0HGIfi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 04:35:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54179 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab0HGIff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 04:35:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vystxuU9+DX37z7mdQTrUAPZiL7q+FPvE+7LPY1gcauvbGOVrx3LWKIKklfZIqvQlu
         nFY/gAkzKBMQpQKM+wouRgJKvSr9fpxz74xSfPg4ovMT4t8epuwb8DGAKmfSWGYqjbuZ
         gEUhEGXW8B4Ipp+mYfmRiJIuAlouilRf3SoeE=
MIME-Version: 1.0
In-Reply-To: <201008070954.08613.arnd@arndb.de>
References: <20100807192122.2005c856@tom-lei>
	<201008070954.08613.arnd@arndb.de>
Date: Sat, 7 Aug 2010 16:35:34 +0800
Message-ID: <AANLkTi=J9OpOcsGH1nGqu5O2O3TRGit3Lh=QUQL_u6Er@mail.gmail.com>
Subject: Re: TTY: warning in tty_lock on 2.6.35+gregkh tree
From: Ming Lei <tom.leiming@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/7 Arnd Bergmann <arnd@arndb.de>:
> On Saturday 07 August 2010, Ming Lei wrote:
>> Following the ttty warning during kernel boot, seems it is for a long time
>> in gregkh's tree.
>
> The fix for this is in the bkl/core tree, meaning it doesn't show up
> in the linux-next tree.
>
> The warning by itself is harmless, so there was no strict need to
> coordinate this better. In fact, with the removal of the optional
> BKL behavior, I believe the warning is now gone from the tty
> tree as well.

Oh, I see, thanks.

-- 
Lei Ming
