Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab0GVBV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 21:21:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62885 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752657Ab0GVBVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 21:21:54 -0400
Message-ID: <4C479C3D.8010209@cn.fujitsu.com>
Date: Thu, 22 Jul 2010 09:17:49 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 3/6] KVM: MMU: fix page dirty tracking lost while sync
 page
References: <4C3FCFD7.5070005@cn.fujitsu.com> <4C3FD11D.1060104@cn.fujitsu.com> <4C473DB3.7040405@redhat.com>
In-Reply-To: <4C473DB3.7040405@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:

> Later on we can use the dirty bit instead of writeable bit, except on
> EPT.  But let's start with your fix.
> 

I'm doing it, will post it... :-)
