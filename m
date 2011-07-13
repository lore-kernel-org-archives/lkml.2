Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab1GMNZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 09:25:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275Ab1GMNZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 09:25:14 -0400
Message-ID: <4E1D9CB2.3070207@redhat.com>
Date: Wed, 13 Jul 2011 16:25:06 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: Apply required parentheses in __check_direct_spte_mmio_pf
References: <4E1B4CF8.605@cn.fujitsu.com> <4E1B5018.7070008@cn.fujitsu.com> <4E1CA7D6.4090203@web.de>
In-Reply-To: <4E1CA7D6.4090203@web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2011 11:00 PM, Jan Kiszka wrote:
> From: Jan Kiszka<jan.kiszka@siemens.com>
>
> Comparison takes precedence over bitwise&, but the latter needs to be
> evaluated first here.
>

Thanks, applied.

> Avi, how's your 32-bit buildbot?

Seems to be working perfectly.

-- 
error compiling committee.c: too many arguments to function

