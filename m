Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859Ab0HJUUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 16:20:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45389 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757811Ab0HJUUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 16:20:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=h8tSJmtxcTVKx4CA2niIKN25WyusxBls7bpmeAltLIr3GcD24QyBz2ZRfHUCdmpH6U
         ImEGyA29yK7fM3Qmac7fNmGpZn0tRFNuTtuQsfFbOcFOgNXKTGz2mwBhQPpUOcs+Hahp
         xHyB+tQi9BYJptu4MlxbCmIegPQVkcSmoMTYo=
Message-ID: <4C61B49D.3000508@gmail.com>
Date: Tue, 10 Aug 2010 22:20:45 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Alexander <aledin@evpatoria.com.ua>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] char: mxser.c, tty->driver_data is not set, kernel 2.6.33.7
References: <4C61605E.1080508@evpatoria.com.ua>
In-Reply-To: <4C61605E.1080508@evpatoria.com.ua>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2010 04:21 PM, Alexander wrote:
> Hello,
> 
> tty->driver_data is not initialized in drivers/char/mxser.c, so it results in
> something like this:
> 
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000007c
> IP: [<d098753f>] mxser_change_speed+0x1f/0x5e0 [mxser]
> ...

Could you resend to stable@kernel.org with a note that this is backport
of 6f08b72cdd4b99a190c4e1fcddd63b401e5b572d?

thanks,
-- 
js
