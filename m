Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab1GGIwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 04:52:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721Ab1GGIv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 04:51:28 -0400
Date: Thu, 7 Jul 2011 05:15:41 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 05/19] KVM: MMU: optimize to handle dirty bit
Message-ID: <20110707081540.GA8334@amt.cnet>
References: <4E0C3178.2080603@cn.fujitsu.com>
 <4E0C320A.8080104@cn.fujitsu.com>
 <20110705192703.GB24417@amt.cnet>
 <4E13B8D4.3050704@cn.fujitsu.com>
 <20110706165134.GC24417@amt.cnet>
 <4E14B39A.5020401@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E14B39A.5020401@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 03:12:26AM +0800, Xiao Guangrong wrote:
> >> So, i think it works well :-)
> > 
> > I think you meant after marking the accessed bit. The dirty bit is set
> > just before returning.
> > 
> 
> In this patch, i moved getting pte_access to the behind of setting dirty bit set

OK

