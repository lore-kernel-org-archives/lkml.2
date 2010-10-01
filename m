Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684Ab0JAPXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 11:23:07 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61060 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab0JAPXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 11:23:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=c6MTWuj99Dl5yJTkBWEyiNjdqNj047ucgde3hqjoAJRyeTKVV5eKTVe5zOFzYuqdoE
         VZouEsjhDV9EwpttiC1jaM5ibuZRHkcgzD+NZfXdSRlO3w3kY7oyiZxK0beFvtDsmdXK
         RgTOiLsVKZTCKKTi8iAn8vTh8xkw1j0NdsxIw=
Date: Fri, 1 Oct 2010 19:22:59 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tobias Klauser <tklauser@distanz.ch>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] altera_uart: Make it possible to use Altera UART
 and 8250 ports together
Message-ID: <20101001152258.GA14846@oksana.dev.rtsoft.ru>
References: <20101001132045.GA9649@oksana.dev.rtsoft.ru>
 <20101001132207.GE25897@oksana.dev.rtsoft.ru>
 <20101001134138.5ea2fb55@linux.intel.com>
 <20101001135254.GA27739@oksana.dev.rtsoft.ru>
 <20101001151841.3fad627c@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101001151841.3fad627c@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 03:18:41PM +0100, Alan Cox wrote:
> > I guess the sane maximum number of ports would be 8, but it is still
> > possible to do hundreds of them.
> 
> In that case you may just want to allocate a dynamic major instead - or
> do you actually need a fixed major/minor for your boot up ?

I don't need it, but someone might.

Plus, it doesn't solve anything as there are only 256 minor numbers. ;-)
If we ever want  to support the insane number of Altera UARTs, we'll
have to solve it very differently. For now, I'd vote for keeping it
simple.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
