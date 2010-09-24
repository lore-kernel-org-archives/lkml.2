Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab0IXHzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 03:55:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43836 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab0IXHzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 03:55:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wU13UNGOCCXEqtdU5JrVQalw2pi4aZ1ErCwdtz/UzxTF+uzEgvpdvi68I7HYHz+3oD
         Hd6yYSSIQYaqRmA2Xt4KMSUQ3K8Q/s2wniStJ2gL1wRjYu/ua/BtrFwjW8Jc0MoNE5ax
         O9d/7FLZSxe4Ze0AZzLaeVrXFLhDdoLdWD9JQ=
Date: Fri, 24 Sep 2010 09:55:34 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Rodolfo Giometti <giometti@linux.it>,
        Peter Zijlstra <peterz@infradead.org>, linux-api@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, linuxppc-dev@lists.ozlabs.org,
        David Miller <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH 1/8] posix clocks: introduce a syscall for clock tuning.
Message-ID: <20100924075534.GB5043@riccoc20.at.omicron.at>
References: <cover.1285261533.git.richard.cochran@omicron.at>
 <b94ef1cd9c04ef3ad5964408bd0af7251add78de.1285261534.git.richard.cochran@omicron.at>
 <1285279423.5158.20.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285279423.5158.20.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 08:03:43AM +1000, Benjamin Herrenschmidt wrote:
> On Thu, 2010-09-23 at 19:31 +0200, Richard Cochran wrote:
> > A new syscall is introduced that allows tuning of a POSIX clock. The
> > syscall is implemented for four architectures: arm, blackfin, powerpc,
> > and x86.
> > 
> > The new syscall, clock_adjtime, takes two parameters, the clock ID,
> > and a pointer to a struct timex. The semantics of the timex struct
> > have been expanded by one additional mode flag, which allows an
> > absolute offset correction. When specificied, the clock offset is
> > immediately corrected by adding the given time value to the current
> > time value.
> 
> Any reason why you CC'ed device-tree discuss ?
> 
> This list is getting way too much unrelated stuff, which I find
> annoying, it would be nice if we were all a bit more careful here with
> our CC lists.

Sorry, I only added device-tree because some one asked me to do so.

    http://marc.info/?l=linux-netdev&m=127273157912358

I'll leave it off next time.

Thanks,
Richard
