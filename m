Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab0FGJAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 05:00:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755444Ab0FGJA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 05:00:29 -0400
Message-ID: <4C0CB610.4010305@redhat.com>
Date: Mon, 07 Jun 2010 17:04:16 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, davem@davemloft.net,
       linux-rdma@vger.kernel.org, sean.hefty@intel.com
Subject: Re: [Patch] infiniband: check local reserved ports
References: <20100603083106.6047.7657.sendpatchset@localhost.localdomain>	<ada1vcoqde3.fsf@roland-alpha.cisco.com> <4C085C9A.30506@redhat.com> <ada1vcmpyvu.fsf@roland-alpha.cisco.com>
In-Reply-To: <ada1vcmpyvu.fsf@roland-alpha.cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/10 00:04, Roland Dreier wrote:
>   >  >  Should this inet_is_reserved_local_port() test apply to all the "port
>   >  >  spaces" that this code is handling?  I honestly am ignorant of the
>   >  >  intended semantics of the new local_reserved_ports stuff, hence my question.
>
>   >  Yes, but I only found this case, is there any else?
>
> My question was more in the other direction: should this test apply to
> all the "port spaces" handled here?  From looking at the code, it
> appears the answer is yes -- it seems that putting a port in
> local_reserved_ports reserves that port for IPv4 and IPv6, UDP, TCP,
> SCTP, DCCP, everything, so we should probably reserve all RDMA CM ports too.

Yes.

So this patch looks good for you? :)

Thanks.

