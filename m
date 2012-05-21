Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759054Ab2EUTx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 15:53:29 -0400
Received: from araneidae.co.uk ([81.187.94.2]:52139 "EHLO
	venus.araneidae.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758563Ab2EUTx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 15:53:28 -0400
Date: Mon, 21 May 2012 20:53:21 +0100 (BST)
From: Michael Abbott <michael@araneidae.co.uk>
To: David Miller <davem@davemloft.net>
cc: ben-linux@fluff.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Implement full reset of DM9000 network device
In-Reply-To: <20120521.153257.724964822171767587.davem@davemloft.net>
Message-ID: <alpine.DEB.2.00.1205212052100.27705@venus.araneidae.co.uk>
References: <alpine.DEB.2.00.1205211344010.26839@venus.araneidae.co.uk> <20120521.153257.724964822171767587.davem@davemloft.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2012, David Miller wrote:
> From: Michael Abbott <michael@araneidae.co.uk>
> Date: Mon, 21 May 2012 13:47:53 +0100 (BST)
> 
> > A Davicom application note for the DM9000 network device recommends 
> > performing software reset twice to correctly initialise the device. 
> > Without this reset some devices fail to initialise correctly on system 
> > startup.
> > 
> > Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>
> 
> Please post networking patches to netdev@vger.kernel.org, the networking 
> developers are not all listening on linux-kernel.
> 
> Plus, by properly submitting networking patches to netdev, it will 
> automatically be queued up and tracked in patchwork:

Ok, thanks.  I'll resubmit when I'm ready -- it seems the patch isn't 
enough to solve the issue I'm investigating...
