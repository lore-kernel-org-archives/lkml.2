Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab0FIMG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 08:06:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813Ab0FIMG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 08:06:57 -0400
Message-ID: <4C0F83DA.9050000@redhat.com>
Date: Wed, 09 Jun 2010 15:06:50 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: MMU: delay local tlb flush
References: <4C0E31F1.70803@cn.fujitsu.com> <4C0E3265.4020601@cn.fujitsu.com>
In-Reply-To: <4C0E3265.4020601@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2010 03:07 PM, Xiao Guangrong wrote:
> delay local tlb flush until enter guest moden, it can reduce vpid flush
> frequency and reduce remote tlb flush IPI(if KVM_REQ_TLB_FLUSH bit is
> already set, IPI is not sent)
>    

Applied all, thanks.

-- 
error compiling committee.c: too many arguments to function

