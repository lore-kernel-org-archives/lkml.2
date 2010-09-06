Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab0IFJTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 05:19:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:33483 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab0IFJTS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 05:19:18 -0400
Subject: Re: [PATCH] KVM: don't sent IPI if the vcpu is not online
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4C84B103.7020603@redhat.com>
Date: Mon, 6 Sep 2010 11:19:16 +0200
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <4D59CC65-7577-4F47-869E-80C87E1C28FE@suse.de>
References: <4C807593.1050903@cn.fujitsu.com> <4C83445B.4020103@redhat.com> <4C844887.9090802@cn.fujitsu.com> <4C84801F.9060803@redhat.com> <DCCDD62D-CE92-453A-BB3C-DF878D893C3F@suse.de> <4C84AC6B.4090306@redhat.com> <633F01D5-D6AD-40F3-8864-C3AE4D314E30@suse.de> <4C84AEF5.2070309@redhat.com> <F83E94AF-6BB0-4653-A81F-7D9F7D0B9E12@suse.de> <4C84B103.7020603@redhat.com>
To: Avi Kivity <avi@redhat.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 06.09.2010, at 11:14, Avi Kivity wrote:

> On 09/06/2010 12:09 PM, Alexander Graf wrote:
>> 
>>> It can also be running host kernel or user code.
>> In that case it's the same as running guest code, no? We'll pass by the vcpu entry check asap.
> 
> Sure, but the IPI is wasted.  If you spend 10% of your time in host code, you can avoid 10% of the IPIs.
> 
> (actually less, since the atomic part of the guest switch has guest_mode enabled)

Oh. My bad. I had a thinko here :).

Sure, sounds like a good idea.


Alex

