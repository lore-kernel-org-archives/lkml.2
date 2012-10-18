Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab2JROcE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:32:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756225Ab2JROcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:32:02 -0400
Message-ID: <50801294.2020007@redhat.com>
Date: Thu, 18 Oct 2012 16:30:44 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: VMX: report internal error for MMIO #PF due
 to delivery event
References: <507E464C.3010108@linux.vnet.ibm.com> <507E4696.7020007@linux.vnet.ibm.com>
In-Reply-To: <507E4696.7020007@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 07:48 AM, Xiao Guangrong wrote:
> The #PF with PFEC.RSV = 1 indicates that the guest is accessing MMIO, we
> can not fix it if it is caused by delivery event. Reporting internal error
> for this case

Applied, thanks.


-- 
error compiling committee.c: too many arguments to function
