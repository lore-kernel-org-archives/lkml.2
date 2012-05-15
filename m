Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966061Ab2EORYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 13:24:46 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50604 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966045Ab2EORYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 13:24:43 -0400
Subject: Re: [V2 PATCH 1/9] macvtap: zerocopy: fix offset calculation when
 building skb
From: Shirley Ma <mashirle@us.ibm.com>
To: Jason Wang <jasowang@redhat.com>
Cc: eric.dumazet@gmail.com, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        davem@davemloft.net
In-Reply-To: <20120502034130.11782.25906.stgit@amd-6168-8-1.englab.nay.redhat.com>
References: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>
	 <20120502034130.11782.25906.stgit@amd-6168-8-1.englab.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 May 2012 10:17:46 -0700
Message-ID: <1337102266.8220.6.camel@oc3660625478.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051517-8974-0000-0000-0000091DBA4A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 11:41 +0800, Jason Wang wrote:
> This patch fixes the offset calculation when building skb:
> 
> - offset1 were used as skb data offset not vector offset
> - reset offset to zero only when we advance to next vector

I tested the original code in all scenario, it worked well.

However this patch makes the code more clear.

Thanks
Shirley

