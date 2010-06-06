Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab0FFKwQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 06:52:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755058Ab0FFKwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 06:52:14 -0400
Message-ID: <4C0B7DD8.1010008@redhat.com>
Date: Sun, 06 Jun 2010 13:52:08 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/7] KVM: MMU: skip invalid sp when unprotect page
References: <4C090511.60206@cn.fujitsu.com>
In-Reply-To: <4C090511.60206@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2010 04:52 PM, Xiao Guangrong wrote:
> In kvm_mmu_unprotect_page(), the invalid sp can be skipped
>    

Applied all, thanks.

-- 
error compiling committee.c: too many arguments to function

