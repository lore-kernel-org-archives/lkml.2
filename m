Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab2JQNOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 09:14:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859Ab2JQNOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 09:14:52 -0400
Message-ID: <507EAF34.30909@redhat.com>
Date: Wed, 17 Oct 2012 15:14:28 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 1/6] KVM: MMU: fix release noslot pfn
References: <507D4DE7.5080708@linux.vnet.ibm.com>
In-Reply-To: <507D4DE7.5080708@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 02:07 PM, Xiao Guangrong wrote:
> We can not directly call kvm_release_pfn_clean to release the pfn
> since we can meet noslot pfn which is used to cache mmio info into
> spte

Applied to master for 3.7, 3.6, thanks.


-- 
error compiling committee.c: too many arguments to function
