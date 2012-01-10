Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab2AJEpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 23:45:52 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:54625 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062Ab2AJEpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 23:45:50 -0500
Message-ID: <4F0BC273.3080707@linux.vnet.ibm.com>
Date: Tue, 10 Jan 2012 12:45:39 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/8] KVM: MMU: combine unsync and unsync_children
References: <4EEB19AF.5070501@linux.vnet.ibm.com> <4EEB19D6.60101@linux.vnet.ibm.com> <20120109111638.GA5255@amt.cnet>
In-Reply-To: <20120109111638.GA5255@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12011004-8256-0000-0000-000000CBBCA5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2012 07:16 PM, Marcelo Tosatti wrote:


> In general, given the number of optimizations made to the shadow mmu
> code, and the fact that over time NPT will dominate, i'd suggest time
> should be spent improving other areas.
> 

I totally agree with you, thanks Marcelo!

