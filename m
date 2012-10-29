Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861Ab2J2SRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 14:17:22 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:45949 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932181Ab2J2SRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 14:17:20 -0400
Date: Mon, 29 Oct 2012 11:17:19 -0700 (PDT)
From: Shreyas Bhatewara <sbhatewara@vmware.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "VMware, Inc." <pv-drivers@vmware.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jongman heo <jongman.heo@samsung.com>,
        David Miller <davem@davemloft.net>
Message-ID: <428233753.11168915.1351534639870.JavaMail.root@vmware.com>
In-Reply-To: <1351531849.12280.54.camel@edumazet-glaptop>
Subject: Re: [PATCH] vmxnet3: must split too big fragments
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [116.75.3.98]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Win)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: Eric Dumazet <edumazet@google.com>
> 
> vmxnet3 has a 16Kbytes limit per tx descriptor, that happened to work
> as long as we provided PAGE_SIZE fragments.
> 
> Our stack can now build larger fragments, so we need to split them to
> the 16kbytes boundary.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: jongman heo <jongman.heo@samsung.com>
> Tested-by: jongman heo <jongman.heo@samsung.com>
> Cc: Shreyas Bhatewara <sbhatewara@vmware.com>
> ---
>  drivers/net/vmxnet3/vmxnet3_drv.c |   65
>  +++++++++++++++++++---------
>  1 file changed, 45 insertions(+), 20 deletions(-)
> 

Thanks for the patch Eric.

Signed-of-by: Shreyas Bhatewara <sbhatewara@vmware.com>
