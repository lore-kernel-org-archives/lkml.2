Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab2DDMZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 08:25:43 -0400
Received: from fw.wantstofly.org ([80.101.37.227]:63438 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab2DDMZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 08:25:42 -0400
Date: Wed, 4 Apr 2012 14:25:40 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 2/5] net: remove ixp2000 ethernet driver
Message-ID: <20120404122540.GA28523@wantstofly.org>
References: <1333503243-7702-1-git-send-email-robherring2@gmail.com>
 <1333503243-7702-2-git-send-email-robherring2@gmail.com>
 <1333534857.3046.33.camel@jtkirshe-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333534857.3046.33.camel@jtkirshe-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 03:20:57AM -0700, Jeff Kirsher wrote:

> > From: Rob Herring <rob.herring@calxeda.com>
> > 
> > The platform is removed, so there are no users of this driver.
> > 
> > Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> > Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> > Cc: Bruce Allan <bruce.w.allan@intel.com>
> > Cc: Carolyn Wyborny <carolyn.wyborny@intel.com>
> > Cc: Don Skidmore <donald.c.skidmore@intel.com>
> > Cc: Greg Rose <gregory.v.rose@intel.com>
> > Cc: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
> > Cc: Alex Duyck <alexander.h.duyck@intel.com>
> > Cc: John Ronciak <john.ronciak@intel.com>
> > Cc: netdev@vger.kernel.org

Acked-by: Lennert Buytenhek <buytenh@wantstofly.org>
