Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644Ab2GKNc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:32:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757624Ab2GKNcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:32:55 -0400
Message-ID: <4FFD807D.1020509@redhat.com>
Date: Wed, 11 Jul 2012 16:32:45 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v7 02/10] KVM: MMU: abstract spte write-protect
References: <4FE1822D.8010002@linux.vnet.ibm.com> <4FE1825B.1030402@linux.vnet.ibm.com> <20120620180254.8b3a42f8.yoshikawa.takuya@oss.ntt.co.jp> <4FE193AA.8010801@linux.vnet.ibm.com> <20120620215653.15930f3467bc13748d548b0d@gmail.com> <4FE1CE43.9080203@linux.vnet.ibm.com> <20120620231112.440df9ae19c1aca36100b746@gmail.com> <4FE27D55.4040805@linux.vnet.ibm.com>
In-Reply-To: <4FE27D55.4040805@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 04:48 AM, Xiao Guangrong wrote:
> On 06/20/2012 10:11 PM, Takuya Yoshikawa wrote:
> 
> 
>> We can change the debug message later if needed.
> 
> 
> Actually, i am going to use tracepoint instead of
> these debug code.

Yes, these should be in the kvmmmu namespace.


-- 
error compiling committee.c: too many arguments to function


