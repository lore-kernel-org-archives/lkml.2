Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab1ACKvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 05:51:41 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64207 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab1ACKvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 05:51:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gI8hxRoUgArH04UFh6sw4qoAShu9XJ3s1We1CxYKiHTSTfXaJR95P29urLvCRMlWNz
         7YkgBVmERymOmUGyohCowtI9303KRElPEUFv7tUKtik647VFJ9iaIbWBV8vFDrBkFyyp
         I+lZFEPUjsQjoVF0T3zRrYX434CpUzzjAy3lw=
Date: Mon, 3 Jan 2011 12:51:25 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>, Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V8 08/13] posix clocks: cleanup the CLOCK_DISPTACH macro
Message-ID: <20110103115125.GA3231@riccoc20.at.omicron.at>
References: <cover.1293820862.git.richard.cochran@omicron.at>
 <503cd1fa268867573001cfc9bb5681ee3b5b32fa.1293820862.git.richard.cochran@omicron.at>
 <1294046949.2016.36.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294046949.2016.36.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 10:29:09AM +0100, Peter Zijlstra wrote:
> On Fri, 2010-12-31 at 20:15 +0100, Richard Cochran wrote:
> > +#define CLOCK_DISPATCH(clock, call, arglist) dispatch_##call arglist
> 
> How about you run something like:
> 
>  :% s/CLOCK_DISPATCH([^,]*, \([^,]*\), \([^)]*)\))/dispatch_\1\2/g
> 
> and remove that cruft all together?

Gladly ;^)

Richard

