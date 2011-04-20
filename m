Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab1DTVP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 17:15:26 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:49414 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab1DTVPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 17:15:24 -0400
Subject: Re: [PATCH V3 5/8] Enable cxgb3 to support zerocopy
From: Shirley Ma <mashirle@us.ibm.com>
To: Dimitris Michailidis <dm@chelsio.com>
Cc: David Miller <davem@davemloft.net>, mst@redhat.com,
        Eric Dumazet <eric.dumazet@gmail.com>, Avi Kivity <avi@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1303333134.19336.70.camel@localhost.localdomain>
References: <1303328216.19336.18.camel@localhost.localdomain>
	 <1303330438.19336.57.camel@localhost.localdomain>
	 <4DAF479D.7090309@chelsio.com>
	 <1303333134.19336.70.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Apr 2011 14:15:14 -0700
Message-ID: <1303334114.19336.72.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-20 at 13:58 -0700, Shirley Ma wrote:
> This flag can be ON when HIGHDMA and scatter/gather support. I will
> modify the patch to make it conditionally.

Double checked, it only needs HIGHDMA condition, not scatter/gather.

thanks
Shirley

