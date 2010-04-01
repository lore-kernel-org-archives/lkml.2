Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab0DAJIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 05:08:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62618 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754193Ab0DAJIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 05:08:15 -0400
Message-ID: <4BB461E7.9000109@cn.fujitsu.com>
Date: Thu, 01 Apr 2010 17:05:43 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Marcelo Tosatti <mtosatti@redhat.com>,
       Sheng Yang <sheng@linux.intel.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] KVM MMU: thinking of shadow page cache
References: <4BB15B1A.7090901@cn.fujitsu.com> <4BB1FD69.6040409@redhat.com>
In-Reply-To: <4BB1FD69.6040409@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:

>>    
> 
> We've considered this in the past, it makes sense.  The big question is
> whether any guests actually map the same page table through PDEs with
> different permissions (mapping the same page table through multiple PDEs
> is very common, but always with the same permissions).  Do you know of
> any such guest?

I also don't know whether have such guest.
Maybe my idea is no good for current OS, thanks for your comments.

Xiao
