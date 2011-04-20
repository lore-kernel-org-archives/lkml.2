Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab1DTU7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:59:05 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:40692 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab1DTU7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:59:02 -0400
Subject: Re: [PATCH V3 5/8] Enable cxgb3 to support zerocopy
From: Shirley Ma <mashirle@us.ibm.com>
To: Dimitris Michailidis <dm@chelsio.com>
Cc: David Miller <davem@davemloft.net>, mst@redhat.com,
        Eric Dumazet <eric.dumazet@gmail.com>, Avi Kivity <avi@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4DAF479D.7090309@chelsio.com>
References: <1303328216.19336.18.camel@localhost.localdomain>
	 <1303330438.19336.57.camel@localhost.localdomain>
	 <4DAF479D.7090309@chelsio.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Apr 2011 13:58:54 -0700
Message-ID: <1303333134.19336.70.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-20 at 13:52 -0700, Dimitris Michailidis wrote:
> The features handling has been reworked in net-next and patches like
> this 
> won't apply as the code you're patching has changed.  Also core code
> now 
> does a lot of the related work and you'll need to tell it what to do
> with 
> any new flags.
Ok, will do.

> What properties does a device or driver need to meet to set this flag?
> It 
> seems to be set a bit too unconditionally.  For example, does it work
> if one 
> disables scatter/gather? 

This flag can be ON when HIGHDMA and scatter/gather support. I will
modify the patch to make it conditionally.

thanks
Shirley

