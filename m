Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461Ab2HJT6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 15:58:40 -0400
Received: from smtp5.mail.ru ([94.100.176.132]:41645 "EHLO smtp5.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757910Ab2HJT5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 15:57:50 -0400
X-Greylist: delayed 2231 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Aug 2012 15:57:50 EDT
Message-ID: <502566EB.3070304@list.ru>
Date: Fri, 10 Aug 2012 23:54:19 +0400
From: Stas Sergeev <stsp@list.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux kernel <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org
Subject: Re: Q: how to control the TTY output queue in real time?
References: <50255E31.8060904@list.ru> <20120810203355.224622cc@pyramind.ukuu.org.uk>
In-Reply-To: <20120810203355.224622cc@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan, thanks, clear enough now. :)

10.08.2012 23:33, Alan Cox wrote:
> 	if (bytes_left < constant)
> 		write_wakeup
>
>
> and I suspect if you made that adjustable and turned off the fifo and any
> other funnies you'd at least make it work for a sufficiently rigged demo.
You suggest to turn off the fifo, sounds worrysome,
does this mean that tcdrain() and TIOCOUTQ do not
account the fifo too?
If they do quite fine with the fifo, then maybe the new
function will do too? Its basically a tcdrain(), just with
the controllable watermark I guess.
