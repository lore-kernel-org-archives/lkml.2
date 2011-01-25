Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab1AYQWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 11:22:25 -0500
Received: from mail.mellanox.co.il ([194.90.237.43]:48605 "EHLO mellanox.co.il"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752564Ab1AYQWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 11:22:24 -0500
Message-ID: <4D3EF8E5.4080607@mellanox.co.il>
Date: Tue, 25 Jan 2011 18:23:01 +0200
From: Tziporet Koren <tziporet@mellanox.co.il>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [GIT PULL] please pull infiniband.git
References: <adaei8byz3n.fsf@cisco.com>
In-Reply-To: <adaei8byz3n.fsf@cisco.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   On 1/17/2011 11:55 PM, Roland Dreier wrote:
> Linus, please pull from
>
>      master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus
>
> This tree is also available from kernel.org mirrors at:
>
>      git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus
>
> This will get the last batch of InfiniBand/RDMA patches for the merge
> window.  The biggest thing here is Tejun's conversion of the RDMA
> stack away from flush_scheduled_work(); the remaining stuff is mostly
> driver fixes, with an SRP compile warning fix and a vzalloc()
> conversion patch thrown in.
Roland,

What about the new mlx4 device IDs?
We wish to have them in for CX3 so that the new kernel will support it

Thanks,
Tziporet
