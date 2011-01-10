Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab1AJHSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 02:18:06 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54853 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab1AJHSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 02:18:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EZ3zHfjrI5sGTlPK0h8JGLsPb5lUvZHBZSUMJgsW/0n5REI/cP901Lxc4Mp8ZjZFZr
         7wCBY62QDwYiJUN5WykdY5czM1LdxAfm1lJFSkCQ+WMrkdFhxnMqwr9UwzjxkpwOvP+f
         KB8SAqDQJOc9LZ/sYN9rBXPLwUdeHwIKaBdtw=
Date: Mon, 10 Jan 2011 08:17:59 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V8 02/13] ntp: add ADJ_SETOFFSET mode bit
Message-ID: <20110110071759.GA4864@riccoc20.at.omicron.at>
References: <cover.1293820862.git.richard.cochran@omicron.at>
 <fe2bec763bec155381d62721aa9da84aeca2785c.1293820862.git.richard.cochran@omicron.at>
 <AANLkTini2WdT-1v4k9V3JOZYDkA59P+SyscTe8-fK2Wk@mail.gmail.com>
 <20110108175028.GA22308@riccoc20.at.omicron.at>
 <AANLkTikigXGSACF6R6kfNHyKZ7GFWrUrCMxygvL3fUC6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikigXGSACF6R6kfNHyKZ7GFWrUrCMxygvL3fUC6@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 06:07:26AM +0900, Kuwahara,T. wrote:
> On Sun, Jan 9, 2011 at 2:50 AM, Richard Cochran
> <richardcochran@gmail.com> wrote:
> > we want to be able to jump the clock arbitrarily.
> 
> Another problem remains:  How do you deal with leap seconds?  I mean,
> given that 1 minute is not always 60 seconds, then what time was it
> XXXXX seconds ago?   Maybe some kind of lookup table is necessary, but
> in such case, isn't it a better choice just to use the
> clock_settime/settimeofday syscall?

Well, first of all, the PTP Hardware Clocks for which this whole patch
set was created in the first place will keep their time as TAI. Adding
seconds to such time values is unambiguous.

Secondly, the question you ask applies equally to the existing
interfaces, so it is a mute point with regard to the patch series.

Richard
