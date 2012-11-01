Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759712Ab2KAKWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 06:22:49 -0400
Received: from intranet.asianux.com ([58.214.24.6]:12459 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758678Ab2KAKWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 06:22:48 -0400
X-Spam-Score: -100.8
Message-ID: <50924DB3.9010601@asianux.com>
Date: Thu, 01 Nov 2012 18:23:47 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [Suggestion] net-ipv6: format %8s change to %16s in rt6_info_route
 function of route.c
References: <50921A92.8000809@asianux.com> <1351760482.32673.913.camel@edumazet-glaptop>
In-Reply-To: <1351760482.32673.913.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年11月01日 17:01, Eric Dumazet 写道:
> Hi Chen
> 
> Thats a good suggestion indeed.
> 

  thank you very much for your confirmation.

> Networking patches should be sent to netdev@vger.kernel.org (added in
> CC)

  I will do it.

> 
> This list only cares about recent generic kernels, not RedHat ones.
> 

  it seems "it is not suitable to send any issues which only relative
with Red Hat to linux-*@vger.kernel.org".



> If you want to provide a patch, please base it on David Miller net-next
> [1] tree, and make it official (read Documentation/SubmittingPatches for
> general advices)
> 

  ok, I will follow, thank you for your information.


> By the way, the %8s should be replaced by %s, there is no need to make
> /proc/net/ipv6_route 'beautiful'. In the past, it was *needed* because
> each line had to be of a given length, but its not anymore the case.
> 
> Thanks
> 

1) I agree with your result.

2) But for the "reason", I have my opinions:
   A) %.8s :  for limitation of output string length.
   B) %8s  :  for width of output string length (but not limit 8).
   C) %8.8s:  both limitation and width.

3) for rt->rt6i_dev->name:
   A) original %8s is not a bug for name len is more than 8 (can still
be outputted correctly)
   B) it is only effect with name len is less than 8 (it will fill some
' ' before the name)
   C) this is the reason why I call it "beautiful", not a bug.


> [1] :
> http://git.kernel.org/?p=linux/kernel/git/davem/net-next.git;a=summary
> 

  I will reference it, thanks.


-- 
Chen Gang

Asianux Corporation
