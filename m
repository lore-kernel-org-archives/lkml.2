Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405Ab0F1JVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 05:21:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777Ab0F1JVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 05:21:32 -0400
Message-ID: <4C286A8F.9080508@redhat.com>
Date: Mon, 28 Jun 2010 17:25:35 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/2] Makefile: fix missing dash when using make LOCALVERSION=xxx
References: <20100628030507.5187.95903.sendpatchset@localhost.localdomain> <alpine.DEB.2.00.1006280207580.28072@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1006280207580.28072@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/10 17:08, David Rientjes wrote:
> On Sun, 27 Jun 2010, Amerigo Wang wrote:
>
>> From: Amerigo Wang<amwang@redhat.com>
>> Date: Mon, 28 Jun 2010 10:42:28 +0800
>>
>> When I use make LOCALVERSION=local and LOCALVERSION_AUTO is not set,
>> I got "2.6.35-rc3local". It is supposed to be "2.6.35-rc3-local".
>>
>
> No, a `-' is not implied when using LOCALVERSION=.

But in your patch description, you said:

     Without CONFIG_LOCALVERSION_AUTO, "make" results in v2.6.32-rc4+
     unless the repository is at the Linux v2.6.32-rc4 commit (in which
     case the version would be v2.6.32-rc4).  If "make LOCALVERSION=kbuild"
     were used, it results in v2.6.32-rc4-kbuild.

So, shouldn't that be "make LOCALVERSION=-kbuild"?

Thanks.

