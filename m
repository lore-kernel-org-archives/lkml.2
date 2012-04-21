Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab2DUBDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 21:03:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036Ab2DUBDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 21:03:18 -0400
Date: Fri, 20 Apr 2012 21:59:16 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 0/9] KVM: MMU: fast page fault
Message-ID: <20120421005916.GA16666@amt.cnet>
References: <4F911B74.4040305@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F911B74.4040305@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 04:16:52PM +0800, Xiao Guangrong wrote:
> Changlog:
> 
> - split the long series for better review. This is the core
>   implementation of fast page fault.
> - document fast page fault in locking.txt

Great, this is a big improvement, thanks.

