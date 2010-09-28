Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110Ab0I1JBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 05:01:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab0I1JBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 05:01:07 -0400
Message-ID: <4CA1AECA.9090409@redhat.com>
Date: Tue, 28 Sep 2010 11:00:58 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/7] KVM: MMU: cleanup for error mask set while walk guest
 page table
References: <4CA06BA4.4090303@cn.fujitsu.com> <4CA06BEF.7060401@cn.fujitsu.com> <4CA0AA7E.4090901@redhat.com> <4CA1AE18.7070200@cn.fujitsu.com>
In-Reply-To: <4CA1AE18.7070200@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/28/2010 10:58 AM, Xiao Guangrong wrote:
> Yeah, it's a good idea, i'll post a patch to do it.
>
> >  Not sure how that interacts with nested
> >  ept (which has a different permission model).
> >
>
> Umm, we just move the error code parsing from the caller site to FNAME(walk_addr)
> function, i think it not make trouble for implement nested ept.

It means the nept code will have to take the ept error code and convert 
it to the standard error code.  Not too difficult.

-- 
error compiling committee.c: too many arguments to function

