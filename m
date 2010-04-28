Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab0D1R7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 13:59:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:28528 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab0D1R7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 13:59:34 -0400
Message-ID: <4BD87781.8030907@retis.net.pl>
Date: Wed, 28 Apr 2010 19:59:29 +0200
From: Grzegorz Chwesewicz <grzegorz.chwesewicz@retis.net.pl>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       eric.dumazet@gmail.com
Subject: Re: Problem with "tcp: bind() fix when many ports are bound" commit
References: <4BD82B29.3000105@retis.net.pl> <20100428.095032.32709294.davem@davemloft.net>
In-Reply-To: <20100428.095032.32709294.davem@davemloft.net>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller pisze:
> From: Grzegorz Chwesewicz <grzegorz.chwesewicz@retis.net.pl>
> Date: Wed, 28 Apr 2010 14:33:45 +0200
> 
>> 	Hi, I have a problem with binding to port with the latest git kernel
>> (my HEAD is at 1600f9def09de07c5dbeb539e978fa73880690dd). Please CC to
>> me as I'm not subscribed to the list.
> 
> Please send networking bug reports CC:'d to netdev and the people
> who wrote and signed off on the commit you've narrowed down the
> problem to.
> 
> Otherwise the appropriate people will take longer to find out about
> your bug, and therefore the bug will take longer to fix than
> necessary.
> 
> Thanks.

OK, thanks, next time I'll do like you said.

-- 
Pozdrawiam
Grzegorz Chwesewicz
mailto:grzegorz.chwesewicz@retis.net.pl
