Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901Ab0D3RQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:16:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932524Ab0D3RQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:16:00 -0400
Message-ID: <4BDAA8B8.9030103@redhat.com>
Date: Fri, 30 Apr 2010 12:54:00 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] KVM MMU: allow shadow page become unsync at creating
 time
References: <4BDA9C37.9070602@cn.fujitsu.com> <4BDA9C86.8080204@cn.fujitsu.com> <4BDA9CD0.6070501@cn.fujitsu.com>
In-Reply-To: <4BDA9CD0.6070501@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2010 12:03 PM, Xiao Guangrong wrote:
> Allow new shadow page become unsync when is created, then we no need
> write-protect the 'sp->gfn', this idea is from Avi:
>
> |Another interesting case is to create new shadow pages in the unsync
> |state. That can help when the guest starts a short lived process: we
> |can avoid write protecting its pagetables completely
>
>    

Any idea how this improves performance?  A kernel build has a lot of 
short lived processes, might see an improvement there.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

