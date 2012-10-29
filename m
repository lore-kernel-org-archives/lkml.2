Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab2J2Wco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:32:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab2J2Wcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 18:32:43 -0400
Date: Mon, 29 Oct 2012 20:31:11 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 2/6] KVM: MMU: remove mmu_is_invalid
Message-ID: <20121029223111.GB8188@amt.cnet>
References: <507D4DE7.5080708@linux.vnet.ibm.com>
 <507D4E21.6010202@linux.vnet.ibm.com>
 <507EC360.8010208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507EC360.8010208@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 04:40:32PM +0200, Avi Kivity wrote:
> On 10/16/2012 02:08 PM, Xiao Guangrong wrote:
> > Remove mmu_is_invalid and use is_invalid_pfn instead
> 
> 
> Applied 2-5 to next; 6 depends on 1, so will wait until it is merged
> upstream.

Applied 6.

