Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab1AJUr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 15:47:56 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46574 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab1AJUry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 15:47:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=OnsoOiuqPoB41wc7muLfX6ziRPn4oH8KhTQETHRwBwxYmVUV+6Ah94tZ8fZfOToxW8
         LLXAHOb/MVxpHAQzipvKB71UIZigJU9zR1tVWJQRbPikzOHVyxH/hZdbZEKvT6+PCC63
         HpbFNrhZbXd2ktIaG6DTKV9z+4R0qbceVIklg=
MIME-Version: 1.0
In-Reply-To: <20110110071759.GA4864@riccoc20.at.omicron.at>
References: <cover.1293820862.git.richard.cochran@omicron.at>
 <fe2bec763bec155381d62721aa9da84aeca2785c.1293820862.git.richard.cochran@omicron.at>
 <AANLkTini2WdT-1v4k9V3JOZYDkA59P+SyscTe8-fK2Wk@mail.gmail.com>
 <20110108175028.GA22308@riccoc20.at.omicron.at> <AANLkTikigXGSACF6R6kfNHyKZ7GFWrUrCMxygvL3fUC6@mail.gmail.com>
 <20110110071759.GA4864@riccoc20.at.omicron.at>
From: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>
Date: Tue, 11 Jan 2011 05:47:13 +0900
Message-ID: <AANLkTimS0-ih=WZ_GvPi9NFjbYMT4OctWV943ri4GuTD@mail.gmail.com>
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

On Mon, Jan 10, 2011 at 4:17 PM, Richard Cochran
<richardcochran@gmail.com> wrote:
> the PTP Hardware Clocks for which this whole patch
> set was created in the first place will keep their time as TAI.

Are you sure of that?  I don't have the standard handy (it's non-free,
right?) but it seems that the Annex B states differently.  But that's
not the point anyway.  My concern is that your patch not only adds the
useless (and broken) feature to the existing syscall but also makes a
permanent change to the public interface for your own use.  That's
what I'm against.  So if you stop touching the struct timex, I won't
complain anymore.
