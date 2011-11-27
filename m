Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab1K0KT0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 05:19:26 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51726 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751298Ab1K0KTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 05:19:24 -0500
X-Sasl-enc: EGwkh7+1FTlTJPx5kZlbJsOemh2QVPdP1YM+kAsJpYwv 1322389161
Date: Sat, 26 Nov 2011 20:16:42 -0800
From: Greg KH <greg@kroah.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Anantha Narayanan <Anantha.Narayanan@intel.com>,
        Samu Onkalo <samu.p.onkalo@nokia.com>, Hemanth V <hemanthv@ti.com>,
        Christoph Mair <christoph.mair@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Gardner <bgardner@wabtec.com>, Minkyu Kang <mk7.kang@samsung.com>,
        Kalhan Trisal <kalhan.trisal@intel.com>,
        "Darrick J. Wong" <djwong@us.ibm.com>, Daniel Mack <zonque@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>, Arnd Bergmann <arnd@arndb.de>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Anatolij Gustschin <agust@denx.de>
Subject: Re: [PATCH 1/2] MISC: convert drivers/misc/* to use
 module_i2c_driver()
Message-ID: <20111127041642.GA16385@kroah.com>
References: <1322194447.30842.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322194447.30842.0.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 25, 2011 at 12:14:07PM +0800, Axel Lin wrote:
> This patch converts the drivers in drivers/misc/* to use the
> module_i2c_driver() macro which makes the code smaller and a bit
> simpler.

Can you hang on to these patches until after 3.3-rc1 is out and the
macros are in Linus's tree?  That way the cross-tree dependancy will not
be there and all of the individual subsystem maintainers can apply
things without having any problems.

thanks,

greg k-h
