Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab1ALMR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 07:17:58 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64852 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840Ab1ALMR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 07:17:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IU90BQwEmXXNT7QD5agI415zqNzMVrpwiBh4nIqLAsEEMjwYWushgTl37yJPpEN5GW
         ubeIRUHgPpWZyT8atLYoVro+Ug8c5lfqrzWNJUlZLijUnbuYi3g/tHtOD9VfO2dqnfYg
         otQzcIMciwBH49XNsVaU4C12xW+QhDkxPtBPo=
Date: Wed, 12 Jan 2011 13:17:52 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>
Subject: Re: [PATCH V8 08/13] posix clocks: cleanup the CLOCK_DISPTACH macro
Message-ID: <20110112121752.GA2800@riccoc20.at.omicron.at>
References: <cover.1293820862.git.richard.cochran@omicron.at>
 <503cd1fa268867573001cfc9bb5681ee3b5b32fa.1293820862.git.richard.cochran@omicron.at>
 <alpine.LFD.2.00.1101111224280.12146@localhost6.localdomain6>
 <20110112073728.GA2935@riccoc20.at.omicron.at>
 <alpine.LFD.2.00.1101121201080.12146@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1101121201080.12146@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 12:16:10PM +0100, Thomas Gleixner wrote:
> 
> We probably can remove the dispatch inlines that way completely and do
> the call directly from the syscall function.

Right, okay. I also wanted to put the whole logic into the syscall
itself. I'll try it that way.

Thanks,

Richard
