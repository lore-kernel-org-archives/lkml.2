Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab0JKAla (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 20:41:30 -0400
Received: from mail.perches.com ([173.55.12.10]:2750 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529Ab0JKAl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 20:41:29 -0400
Subject: Re: [RFC PATCH net-next] drivers/net Documentation/networking:
 Create directory intel_wired_lan
From: Joe Perches <joe@perches.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        e1000-devel <e1000-devel@lists.sourceforge.net>
In-Reply-To: <20101010144440.0d7a69f9@nehalam>
References: <1286743352.11039.165.camel@Joe-Laptop>
	 <20101010144440.0d7a69f9@nehalam>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Oct 2010 17:41:27 -0700
Message-ID: <1286757687.11039.173.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-10 at 14:44 -0700, Stephen Hemminger wrote:
> On Sun, 10 Oct 2010 13:42:32 -0700
> Joe Perches <joe@perches.com> wrote:
> > Perhaps it's better to move drivers from the very populated
> > drivers/net directory into vendor specific directories similar
> > to the Atheros approach used for drivers/net/wireless/ath/
> > Move intel drivers and Documentation to separate directories
> Seems like it would introduce more confusion and trouble.

It would also allow common code to be consolidated from the
various drivers.


