Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab2GXCNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 22:13:49 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:57352 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab2GXCNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 22:13:48 -0400
Message-ID: <500E04BC.8090409@linux.vnet.ibm.com>
Date: Tue, 24 Jul 2012 10:13:16 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/3] KVM: remove dummy pages
References: <500D59A7.9060503@linux.vnet.ibm.com>
In-Reply-To: <500D59A7.9060503@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12072402-6102-0000-0000-000001EF137B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2012 10:03 PM, Xiao Guangrong wrote:
> Currently, kvm allocates some pages and use then as error indicators,
> it wastes memory and is not good for scalability.
> 
> In this patchset, we introduce some error code instead of the pages to
> indicate the error conditions.
> 

Sorry for the noise, there are some typos in the title and in the change-logs,
I will correct them after you guys review the patches.

