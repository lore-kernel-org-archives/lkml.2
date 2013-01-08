Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab3AHLtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 06:49:06 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21738 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab3AHLtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 06:49:04 -0500
Date: Tue, 8 Jan 2013 14:48:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: masa-korg@dsn.okisemi.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: Re: add Packet hub driver for Topcliff Platform controller hub
Message-ID: <20130108114846.GQ7302@mwanda>
References: <20130107090210.GA20716@elgon.mountain>
 <201301081049.15118.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201301081049.15118.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 10:49:14AM +0000, Arnd Bergmann wrote:
> On Monday 07 January 2013, Dan Carpenter wrote:
> > Sorry my question is about an old patch.  Smatch complains because we
> > only pass a PAGE_SIZE buffer to sysfs files so the test for
> > "if (count > PCH_PHUB_OROM_SIZE) {" makes it think we are overflowing.
> > In fact, count is never more than 4096 so there is no overflow, but I
> > also think that it means only the first 4096 bytes of the firmware gets
> > updated.
> 
> I think it works correctly as long as user space keeps writing into the
> bin file when getting short write return (4096 bytes).
> 

Ah.  Ok.  I misunderstood.  I've looked through it again and you're
right.

Sorry for the noise.

regards,
dan carpenter

