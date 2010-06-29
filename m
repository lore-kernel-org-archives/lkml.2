Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab0F2BXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 21:23:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56010 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751365Ab0F2BXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 21:23:12 -0400
Message-ID: <4C294A1E.1070602@cn.fujitsu.com>
Date: Tue, 29 Jun 2010 09:19:26 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/10] KVM: MMU: fix writable sync sp mapping
References: <4C249B84.4080703@cn.fujitsu.com> <4C2704CF.6040401@cn.fujitsu.com> <4C2868C9.8040302@redhat.com> <4C286E1A.7070003@cn.fujitsu.com> <4C288A6E.6060500@redhat.com>
In-Reply-To: <4C288A6E.6060500@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:

> 
> 
> I think I see.  So, after A, the pages are write protected, but are
> still marked as unsync.  In B, we're testing SP2->unsync, which we plan
> to sync soon, but haven't yet.  So the test for s->unsync is incorrect.
> 

Right.

> So the patch is right.  Thanks for the explanation.  Please update the
> changelog to note that sp->unsync is not reliable during resync, this is
> tricky stuff.
> 

OK, will do it in the next version.
