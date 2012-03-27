Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074Ab2C0Guo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 02:50:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:58683 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174Ab2C0Gum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 02:50:42 -0400
Message-ID: <1332831027.2882.55.camel@pasglop>
Subject: Re: [PATCH v2] powerpc+sparc/vio: Modernize driver registration
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: gregkh@linuxfoundation.org
Cc: key@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, David Miller <davem@davemloft.net>
Date: Tue, 27 Mar 2012 17:50:27 +1100
In-Reply-To: <20120327.015316.1552473998755517441.davem@davemloft.net>
References: <1332824790.2882.51.camel@pasglop>
	 <20120327.015316.1552473998755517441.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-27 at 01:53 -0400, David Miller wrote:
> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date: Tue, 27 Mar 2012 16:06:30 +1100
> 
> > This makes vio_register_driver() get the module owner & name at compile
> > time like PCI drivers do, and adds a name pointer directly in struct
> > vio_driver to avoid having to explicitly initialize the embedded
> > struct device.
> > 
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> Acked-by: David S. Miller <davem@davemloft.net>
> --

Greg, do you want to carry this or should I ? In the later case, I'd
rather send it to Linus now than having it hanging around til the next
merge window :-)

Cheers,
Ben.


