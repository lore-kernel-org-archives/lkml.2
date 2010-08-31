Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab0HaT1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 15:27:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59356 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab0HaT1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 15:27:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IrNiKemSyEc73dSn22XNGytydMW7Yt/ak+A59xJqprZyoO2wIbujbnxRUG8XtSVo2W
         7jLf8+mnKrx4L+ZXwuXtqHxeMARTkHo6GHxH6dJ7DTmDpLW9b4ZzLQrBsrBZh8GEydg8
         xrzNOTkqEmJy4jWgARMjpUwLeKqw6ILAFe54Y=
Date: Tue, 31 Aug 2010 21:26:59 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [Bug #16626] Machine hangs with EIP at skb_copy_and_csum_dev
Message-ID: <20100831192659.GA3093@del.dom.local>
References: <4LwrqITm-eJ.A.r8G.eFueMB@chimera>
 <4AUWBNzTkbD.A.ey.cGueMB@chimera>
 <courier.4C7C99F2.00001F74@fs.ru.acad.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <courier.4C7C99F2.00001F74@fs.ru.acad.bg>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 08:58:10AM +0300, Plamen Petrov wrote:
> Rafael J. Wysocki ????????????:
> 
> >This message has been generated automatically as a part of a summary report
> >of recent regressions.
> >
> >The following bug entry is on the current list of known regressions
> >from 2.6.35.  Please verify if it still should be listed and let the tracking team
> >know (either way).
> >
> >
> >Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16626
> >Subject		: Machine hangs with EIP at skb_copy_and_csum_dev
> >Submitter	: Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>
> >Date		: 2010-08-19 09:57 (11 days old)
> >Handled-By	:  Eric Dumazet <eric.dumazet@gmail.com>
> >
> >
> 
> Should "generic receive offload" work on a forwarding setup?
> If yes - then the bug should remain open.
> If not - then it's my mistake.

If/since it's on by default it should work and it definitely can't be
your mistake. (Unless we can't find the real reason... ;-)

Jarek P.
