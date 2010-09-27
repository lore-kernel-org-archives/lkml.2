Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab0I0KKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 06:10:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63874 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab0I0KKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 06:10:30 -0400
Message-ID: <4CA06E9C.9060401@cn.fujitsu.com>
Date: Mon, 27 Sep 2010 18:14:52 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/7] KVM: MMU: update 'root_hpa' out of loop in PAE shadow
 path
References: <4CA06BA4.4090303@cn.fujitsu.com>
In-Reply-To: <4CA06BA4.4090303@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2010 06:02 PM, Xiao Guangrong wrote:
> The value of 'vcpu->arch.mmu.pae_root' is not modified, so we can update 'root_hpa'
> out of the loop
> 
> Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

Hi Avi, Marcelo,

I'm so sorry that missed "Signed-off-by: " string in all patches, i'll repost this
patchset after your review. :-(
