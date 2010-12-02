Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026Ab0LBDKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 22:10:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756773Ab0LBDKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 22:10:17 -0500
Message-ID: <4CF70F31.5030204@redhat.com>
Date: Thu, 02 Dec 2010 11:14:57 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: linux-kernel@vger.kernel.org, Jiri Pirko <jpirko@redhat.com>,
        Neil Horman <nhorman@redhat.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        bonding-devel@lists.sourceforge.net, Jay Vosburgh <fubar@us.ibm.com>
Subject: Re: [Patch] bonding: clean up netpoll code
References: <20101201075043.5741.29172.sendpatchset@localhost.localdomain> <20101201081457.23102445@nehalam>
In-Reply-To: <20101201081457.23102445@nehalam>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/10 00:14, Stephen Hemminger wrote:
> On Wed, 1 Dec 2010 02:45:45 -0500
> Amerigo Wang<amwang@redhat.com>  wrote:
>
>> +	if ((slave_dev->npinfo = bond_netpoll_info(bond))) {
>
> Split assignment and conditional into two lines
>

Ok, will change this in the next update.

Thanks!
