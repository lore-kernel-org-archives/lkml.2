Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab0DWLft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 07:35:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710Ab0DWLfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 07:35:47 -0400
Message-ID: <4BD1860E.7000103@redhat.com>
Date: Fri, 23 Apr 2010 14:35:42 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/10] KVM MMU: don't write-protect if have new mapping
 to unsync page
References: <4BCFE581.8050305@cn.fujitsu.com> <4BCFE8F0.7010509@cn.fujitsu.com>
In-Reply-To: <4BCFE8F0.7010509@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2010 09:13 AM, Xiao Guangrong wrote:
> If have new mapping to the unsync page(i.e, add a new parent), just
> update the page from sp->gfn but not write-protect gfn, and if need
> create new shadow page form sp->gfn, we should sync it
>    

Sorry, I don't understand this patch.  Can you clarify?  for example, 
the situation before adding the new parent, what the guest action was, 
and the new situation.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

