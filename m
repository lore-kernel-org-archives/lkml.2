Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852Ab0D0QJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 12:09:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab0D0QJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 12:09:40 -0400
Message-ID: <4BD70C41.2060202@redhat.com>
Date: Tue, 27 Apr 2010 19:09:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/22] KVM: MMU: Introduce kvm_read_guest_page_x86()
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com> <1272364712-17425-16-git-send-email-joerg.roedel@amd.com> <4BD6DE15.8070409@redhat.com> <20100427132030.GH11097@amd.com> <4BD6E80A.2000201@redhat.com> <20100427154024.GL11097@amd.com>
In-Reply-To: <20100427154024.GL11097@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2010 06:40 PM, Joerg Roedel wrote:
>
> Currently its a bit unclear when to use mmu or nested_mmu. With a
> pointer it would be unclear to the code reader when to use the pointer
> and when to select the mmu_contexts directly.
>    

I think in most cases you'd want full translation, thus the pointer.  
This should be the default.  In specific cases you'd want just the 
non-nested guest translation.

-- 
error compiling committee.c: too many arguments to function

