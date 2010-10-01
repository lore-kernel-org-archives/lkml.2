Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab0JAQF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 12:05:26 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64696 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab0JAQFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 12:05:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WPjk+7LHdW/7cboBQ9e8bixqeftn/gTQAkUZ1bIXfjXxA+EAGB9pfNQgRCbOb8OJTF
         hb/VPVVPILL5W87rUchqrFiJUKTToVXInlae85cuilmpudtHhsWFZQYDt9fYkU+tYJwo
         oheVR+QJJdhM7iIKjlMiQR3zPAbMF5mupqZjo=
Date: Fri, 1 Oct 2010 20:05:18 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tobias Klauser <tklauser@distanz.ch>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] altera_uart: Make it possible to use Altera UART
 and 8250 ports together
Message-ID: <20101001160518.GA20335@oksana.dev.rtsoft.ru>
References: <20101001132045.GA9649@oksana.dev.rtsoft.ru>
 <20101001132207.GE25897@oksana.dev.rtsoft.ru>
 <20101001134138.5ea2fb55@linux.intel.com>
 <20101001135254.GA27739@oksana.dev.rtsoft.ru>
 <20101001151841.3fad627c@linux.intel.com>
 <20101001152258.GA14846@oksana.dev.rtsoft.ru>
 <20101001155756.54e9716c@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101001155756.54e9716c@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 03:57:56PM +0100, Alan Cox wrote:
> > I don't need it, but someone might.
> 
> Why ?

No idea. But why you asked in the first place? :-) I thought you
have had some scenario when static major number is necessary.

> > Plus, it doesn't solve anything as there are only 256 minor
> > numbers. ;-) If we ever want  to support the insane number of Altera
> > UARTs, we'll have to solve it very differently. For now, I'd vote for
> > keeping it simple.
> 
> We got past the 256/256 limit some time ago.

Oh? Then using dynamic major makes a lot of sense, thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
