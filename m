Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab0DMBzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 21:55:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56735 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754279Ab0DMBzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 21:55:43 -0400
Message-ID: <4BC3CE83.8020705@cn.fujitsu.com>
Date: Tue, 13 Apr 2010 09:53:07 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] KVM MMU: optimize/cleanup for marking parent unsync
References: <4BC2D2E2.1030604@cn.fujitsu.com> <4BC2D390.7050708@cn.fujitsu.com> <20100412171211.GC4976@amt.cnet>
In-Reply-To: <20100412171211.GC4976@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Marcelo Tosatti wrote:

> Xiao,
> 
> Did you actually see this codepath as being performance sensitive? 

Actually, i not run benchmarks to contrast the performance before this patch
and after this patch.

> 
> I'd prefer to not touch it.

This patch avoids walk all parents and i think this overload is really unnecessary.
It has other tricks in this codepath but i not noticed? :-)

Thanks,
Xiao
