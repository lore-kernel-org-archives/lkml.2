Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab0ICJG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:06:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49467 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab0ICJGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:06:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=osvk46kEFEc53FSlrIGqOYaB4PQQ/86bDZTFZAFAngMwMW65LyCr9hsm7vr6F7brBr
         BW+mhdyOvqJ+f6dqJMpgKecVaBvk8r+v19RC4XlHavxuUxsT48PC23g9KEznMzIY0Xt2
         /qU/61ZaO3GN/bdRJMHTA0oqzSjsg/FeJ0qro=
Date: Fri, 3 Sep 2010 09:06:20 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [Bug #16626] Machine hangs with EIP at skb_copy_and_csum_dev
Message-ID: <20100903090620.GA6645@ff.dom.local>
References: <4LwrqITm-eJ.A.r8G.eFueMB@chimera> <4AUWBNzTkbD.A.ey.cGueMB@chimera> <courier.4C7C99F2.00001F74@fs.ru.acad.bg> <20100831192659.GA3093@del.dom.local> <1283338251.2556.124.camel@edumazet-laptop> <4C80AB34.20501@fs.uni-ruse.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C80AB34.20501@fs.uni-ruse.bg>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 11:00:52AM +0300, Plamen Petrov wrote:
> ???? 01.9.2010 ??. 13:50, Eric Dumazet ????????????:
>
> I confirm that the above patch applied on top of v2.6.36-rc3 does not
> show the problems that all the kernels since v2.6.35 (both stable
> and Linus' tree) had.
>
> My problematic machine has been running the patched 36-rc3 for 36 hours,  
> and couning, with "generic receive offload" enabled only my tg3 nic.
>
> Thank you very much for the wonderful job, Eric!
> Thanks to you, too, Jarek!

Not at all! I only messed up a bit :-(

All credits to Eric and Plamen!

Thanks again,
Jarek P.
