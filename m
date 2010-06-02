Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420Ab0FBS4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 14:56:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57394 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758214Ab0FBS4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 14:56:07 -0400
Date: Wed, 2 Jun 2010 20:56:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: fengguang.wu@intel.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, andi@firstfloor.org
Subject: Re: [PATCH] ipconfig: send host-name in DHCP requests
Message-ID: <20100602185601.GB14221@basil.fritz.box>
References: <20100531031953.GA10590@localhost> <20100602.070531.73368509.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602.070531.73368509.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 07:05:31AM -0700, David Miller wrote:
> From: Wu Fengguang <fengguang.wu@intel.com>
> Date: Mon, 31 May 2010 11:19:53 +0800
> 
> > Normally dhclient can be configured to send the "host-name" option
> > in DHCP requests to update the client's DNS record. However for an
> > NFSROOT system, dhclient shall never be called (which may change the
> > IP addr and therefore lose your root NFS mount connection).
> > 
> > So enable updating the DNS record with kernel parameter
> > 
> > 	ip=::::$HOST_NAME::dhcp
> > 
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> 
> Applied, thanks.

Small nit: Fengguang, please document the new option in 
Documentation/kernel-parameters.txt That could be done in a follow-on patch.

-Andi
> 

-- 
ak@linux.intel.com -- Speaking for myself only.
