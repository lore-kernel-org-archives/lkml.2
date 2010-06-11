Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760395Ab0FKNqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 09:46:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49639 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760322Ab0FKNqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 09:46:53 -0400
Message-ID: <4C123D78.5040705@cn.fujitsu.com>
Date: Fri, 11 Jun 2010 21:43:20 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 7/7] KVM: MMU: don't walk every parent pages while mark
 unsync
References: <4C1239EE.3090904@cn.fujitsu.com> <4C123B93.7060803@cn.fujitsu.com>
In-Reply-To: <4C123B93.7060803@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Xiao Guangrong wrote:
> While we mark the parent's unsync_child_bitmap, if the parent is already
> unsynced, it no need walk it's parent, it can reduce some unnecessary
> workload
> 

Hi Avi, Marcelo,

About two months ago, i have sent this optimization, it just a little performance
improved (~0.5%) at that time, now, we allow more page become unsync, this path is
called higher frequency, during my test, kernelbench show the performance improved
~2%, so, i think we may apply it now :-)
