Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab2JQOlC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:41:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756285Ab2JQOlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:41:00 -0400
Message-ID: <507EC360.8010208@redhat.com>
Date: Wed, 17 Oct 2012 16:40:32 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 2/6] KVM: MMU: remove mmu_is_invalid
References: <507D4DE7.5080708@linux.vnet.ibm.com> <507D4E21.6010202@linux.vnet.ibm.com>
In-Reply-To: <507D4E21.6010202@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 02:08 PM, Xiao Guangrong wrote:
> Remove mmu_is_invalid and use is_invalid_pfn instead


Applied 2-5 to next; 6 depends on 1, so will wait until it is merged
upstream.



-- 
error compiling committee.c: too many arguments to function
