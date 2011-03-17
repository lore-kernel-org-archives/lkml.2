Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab1CQOPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 10:15:03 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:60171 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752001Ab1CQOO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 10:14:59 -0400
X-Sasl-enc: DpwBz+xxHyNbO9sRGGKXP5x37F89fpGU0XaY4/8bWa09 1300371298
Date: Thu, 17 Mar 2011 11:14:55 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: No iproute2 for 2.6.38
Message-ID: <20110317141455.GE1724@khazad-dum.debian.net>
References: <20110315195534.0cc43032@nehalam>
 <4D804EBD.4030904@us.ibm.com>
 <20110316170441.351efba7@nehalam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110316170441.351efba7@nehalam>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Mar 2011, Stephen Hemminger wrote:
> > 2.6.38 includes support for macvlan/macvtap 'passthru' mode that allows 
> > assigning
> > SR-IOV VFs to a KVM guest via macvtap/virtio.
> > It is not possible to support live migration using direct assignment of 
> > VF's to a guest,
> > but 'passthu' assignment makes this possible.
> > 
> > Enabling this feature requires the following patch to iproute2 that 
> > allows creating macvlan
> > device in 'passthru' mode.
> >      http://patchwork.ozlabs.org/patch/69515/
> > Looks like this patch is still marked as 'Awaiting upstream'.
> > 
> > Could you apply this patch and it would be great if a version of 
> > iproute2 is released for 2.6.38.
> 
> Sorry missed it applied to repository, still not sure worth a new release.

Release early, release often.  And someone actually bothered asking you to
specifically, so it clearly is going to be useful to that someone.

So, why not do a 2.6.38 release?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
