Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab2FKXcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 19:32:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664Ab2FKXc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 19:32:29 -0400
Date: Mon, 11 Jun 2012 20:32:12 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 5/9] KVM: MMU: introduce SPTE_MMU_WRITEABLE bit
Message-ID: <20120611233212.GA29573@amt.cnet>
References: <4FC470C7.5040700@linux.vnet.ibm.com>
 <4FC4716A.8030304@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC4716A.8030304@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 02:49:14PM +0800, Xiao Guangrong wrote:
> This bit indicates whether the spte can be writable on MMU, that means
> the corresponding gpte is writable and the corresponding gfn is not
> protected by shadow page protection

Why is this still necessary, now that only sptes of direct shadow pages 
are updated locklessly? 

