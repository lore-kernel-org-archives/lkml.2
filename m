Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab0DLRMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 13:12:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265Ab0DLRMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 13:12:43 -0400
Date: Mon, 12 Apr 2010 14:12:11 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] KVM MMU: optimize/cleanup for marking parent unsync
Message-ID: <20100412171211.GC4976@amt.cnet>
References: <4BC2D2E2.1030604@cn.fujitsu.com>
 <4BC2D390.7050708@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC2D390.7050708@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 04:02:24PM +0800, Xiao Guangrong wrote:
> - 'vcpu' is not used while mark parent unsync, so remove it
> - if it has alread marked unsync, no need to walk it's parent
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

Xiao,

Did you actually see this codepath as being performance sensitive? 

I'd prefer to not touch it.

