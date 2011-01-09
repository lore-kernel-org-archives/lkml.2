Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab1AIVIJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 16:08:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33206 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab1AIVIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 16:08:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=V8VdUg5gnn03UAQyTN8laGGX7kFOZorT3m3W0hPWcEYZHh0ZPk0Yp6hkkgN249V83V
         TcMZtcJBJL+H6pUE058BcS6GvoNULJOVboQkzdqVx4zcyE6VCKgoGOqoTYOOpEDUzGhp
         rv74FCZuR2y/PMSSuB8e80gUjiiRJQUTmms2Y=
MIME-Version: 1.0
In-Reply-To: <20110108175028.GA22308@riccoc20.at.omicron.at>
References: <cover.1293820862.git.richard.cochran@omicron.at>
 <fe2bec763bec155381d62721aa9da84aeca2785c.1293820862.git.richard.cochran@omicron.at>
 <AANLkTini2WdT-1v4k9V3JOZYDkA59P+SyscTe8-fK2Wk@mail.gmail.com> <20110108175028.GA22308@riccoc20.at.omicron.at>
From: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>
Date: Mon, 10 Jan 2011 06:07:26 +0900
Message-ID: <AANLkTikigXGSACF6R6kfNHyKZ7GFWrUrCMxygvL3fUC6@mail.gmail.com>
Subject: Re: [PATCH V8 02/13] ntp: add ADJ_SETOFFSET mode bit
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 9, 2011 at 2:50 AM, Richard Cochran
<richardcochran@gmail.com> wrote:
> we want to be able to jump the clock arbitrarily.

Another problem remains:  How do you deal with leap seconds?  I mean,
given that 1 minute is not always 60 seconds, then what time was it
XXXXX seconds ago?   Maybe some kind of lookup table is necessary, but
in such case, isn't it a better choice just to use the
clock_settime/settimeofday syscall?
