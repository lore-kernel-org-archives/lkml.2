Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab0ESQTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 12:19:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943Ab0ESQTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 12:19:31 -0400
Message-ID: <4BF40F8C.4050608@redhat.com>
Date: Wed, 19 May 2010 19:19:24 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/3] KVM: MMU: split kvm_sync_page() function
References: <4BEE7CAC.5020603@cn.fujitsu.com>
In-Reply-To: <4BEE7CAC.5020603@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2010 01:51 PM, Xiao Guangrong wrote:
> Split kvm_sync_page() into kvm_sync_page() and kvm_sync_page_transient()
> to clarify the code address Avi's suggestion
>
> kvm_sync_page_transient() function only update shadow page but not mark
> it sync and not write protect sp->gfn. it will be used by later patch
>    


Applied all three, thanks.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

