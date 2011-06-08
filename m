Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab1FHJjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 05:39:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:57304 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab1FHJjU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 05:39:20 -0400
Subject: Re: [PATCH 04/15] KVM: MMU: cache mmio info on page fault path
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4DEF41F6.8050204@cn.fujitsu.com>
Date: Wed, 8 Jun 2011 11:39:16 +0200
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <D05F4629-73E0-41CA-A6E4-2475D89E7A3C@suse.de>
References: <4DEE205E.8000601@cn.fujitsu.com> <4DEE20EE.7060000@cn.fujitsu.com> <4FA0E9B8-FBB6-49BD-916C-239599136604@suse.de> <4DEF39CB.4020109@cn.fujitsu.com> <3CA39806-D840-414B-816E-99DAB6F8FEBD@suse.de> <4DEF41F6.8050204@cn.fujitsu.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08.06.2011, at 11:33, Xiao Guangrong wrote:

> On 06/08/2011 05:18 PM, Alexander Graf wrote:
> 
>>> 
>>> Also, when context switched, CR3 is reloaded, mmio cache info can be cleared too. right? :-)
>> 
>> Only when using SPT. In the NPT case, you will never see cr3 getting reloaded or INVLPG :).
>> 
> 
> In the NPT case, we only cache the GPA, GVA is not cached (vcpu.arch.mmio_gva is always 0) ;-)

Ah, very nice! :)


Alex

