Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab0CZQ6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 12:58:51 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:65522 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab0CZQ6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 12:58:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=saDa97SjR36MwscM5i9rzLYY+f/z2VDzuEmj64+5LdXYrzVqxly2W+jLJuK/Fn6Hne
         Sgae0+9WFx0kch6a67Yz8CihiGJG111MoRlgrT9wnt45aR8o/616WT9/ZhniMUy2g8Te
         Ll0VYnJFLLgRfIFE/5Rw4AxHJhi0l2vukCeOc=
Message-ID: <4BACE827.4070006@gmail.com>
Date: Fri, 26 Mar 2010 22:00:23 +0500
From: "Alexander E. Patrakov" <patrakov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100314 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
Newsgroups: gmane.linux.ppp,gmane.linux.kernel,gmane.linux.network
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Richard Hartmann <richih.mailinglist@gmail.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-ppp@vger.kernel.org
Subject: Re: [Patch] fix packet loss and massive ping spikes with PPP multi-link
References: <2d460de71003260850x7f90d04cy79ac853464108182@mail.gmail.com> <20100326160226.0159ac3b@lxorguk.ukuu.org.uk>
In-Reply-To: <20100326160226.0159ac3b@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

26.03.2010 21:02, Alan Cox wrote:

> You can then do this
>
> static int ml_explode = 1;
> module_param(ml_explode, int, 0600);
> MODULE_PARM_DESC(ml_expode, "Set this to zero to disabling multilink \
> 	fragmentation when talking to cisco devices");
>
> which will let you load the module with the option ml_explode = 0 if you
> want that property.
>
> Making it runtime per link selectable would be nicer but thats a bit more
> work.

Doesn't it work already via echoing values to 
/sys/module/ppp/generic/parameters/ml_explode in the above code?

-- 
Alexander E. Patrakov
