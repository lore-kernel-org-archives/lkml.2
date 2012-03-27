Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab2C0OJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 10:09:26 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48483 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab2C0OJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 10:09:25 -0400
Date: Tue, 27 Mar 2012 07:09:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: key@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2] powerpc+sparc/vio: Modernize driver registration
Message-ID: <20120327140920.GB25109@kroah.com>
References: <1332824790.2882.51.camel@pasglop>
 <20120327.015316.1552473998755517441.davem@davemloft.net>
 <1332831027.2882.55.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332831027.2882.55.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 05:50:27PM +1100, Benjamin Herrenschmidt wrote:
> On Tue, 2012-03-27 at 01:53 -0400, David Miller wrote:
> > From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Date: Tue, 27 Mar 2012 16:06:30 +1100
> > 
> > > This makes vio_register_driver() get the module owner & name at compile
> > > time like PCI drivers do, and adds a name pointer directly in struct
> > > vio_driver to avoid having to explicitly initialize the embedded
> > > struct device.
> > > 
> > > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > 
> > Acked-by: David S. Miller <davem@davemloft.net>
> > --
> 
> Greg, do you want to carry this or should I ? In the later case, I'd
> rather send it to Linus now than having it hanging around til the next
> merge window :-)

Feel free to send it now, it looks good to me:
	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
