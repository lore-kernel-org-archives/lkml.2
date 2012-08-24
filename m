Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab2HXHRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 03:17:54 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39978 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab2HXHRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 03:17:48 -0400
Message-ID: <50372A96.1040701@suse.cz>
Date: Fri, 24 Aug 2012 09:17:42 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120731 Thunderbird/15.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: greg@kroah.com, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] tty: move the async flags from the serial code into
 the tty includes
References: <20120822144426.27149.93723.stgit@localhost.localdomain>
In-Reply-To: <20120822144426.27149.93723.stgit@localhost.localdomain>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 04:44 PM, Alan Cox wrote:
> Jiri - this seem more sensible ?

I would be faster if you CCed me :).

> From: Alan Cox <alan@linux.intel.com>
> 
> These are used with the tty_port flags which are tty generic so move the
> flags into a more sensible place. This then makes it possible to add
> helpers such as those suggested by Huang Shijie.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>

Acked-by: Jiri Slaby <jslaby@suse.cz>

>  include/linux/Kbuild      |    1 +
>  include/linux/serial.h    |   75 ++-----------------------------------------
>  include/linux/tty.h       |    1 +
>  include/linux/tty_flags.h |   78 +++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 83 insertions(+), 72 deletions(-)
>  create mode 100644 include/linux/tty_flags.h

thanks,
-- 
js
suse labs
