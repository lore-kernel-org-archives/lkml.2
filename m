Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab1CQAEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 20:04:50 -0400
Received: from mail.vyatta.com ([76.74.103.46]:55221 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab1CQAEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 20:04:45 -0400
Date: Wed, 16 Mar 2011 17:04:41 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Sridhar Samudrala <sri@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: No iproute2 for 2.6.38
Message-ID: <20110316170441.351efba7@nehalam>
In-Reply-To: <4D804EBD.4030904@us.ibm.com>
References: <20110315195534.0cc43032@nehalam>
	<4D804EBD.4030904@us.ibm.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Mar 2011 22:46:37 -0700
Sridhar Samudrala <sri@us.ibm.com> wrote:

> On 3/15/2011 7:55 PM, Stephen Hemminger wrote:
> > I am not going to bother releasing for 2.6.38 the only changes
> > were later reverted.
> 2.6.38 includes support for macvlan/macvtap 'passthru' mode that allows 
> assigning
> SR-IOV VFs to a KVM guest via macvtap/virtio.
> It is not possible to support live migration using direct assignment of 
> VF's to a guest,
> but 'passthu' assignment makes this possible.
> 
> Enabling this feature requires the following patch to iproute2 that 
> allows creating macvlan
> device in 'passthru' mode.
>      http://patchwork.ozlabs.org/patch/69515/
> Looks like this patch is still marked as 'Awaiting upstream'.
> 
> Could you apply this patch and it would be great if a version of 
> iproute2 is released for 2.6.38.
> 
> Thanks
> Sridhar
> 

Sorry missed it applied to repository, still not sure worth a new release.


-- 
