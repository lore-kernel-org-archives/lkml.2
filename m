Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab2DSAIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 20:08:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50214 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab2DSAIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 20:08:46 -0400
Date: Wed, 18 Apr 2012 17:08:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jean Pihet <jean.pihet@newoldbits.com>
Cc: akpm@linux-foundation.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Kevin Hilman <khilman@ti.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, KEERTHY J <j-keerthy@ti.com>,
        Jean Pihet <j-pihet@ti.com>
Subject: Re: [PATCH v2 0/9] PM: Create the AVS class of drivers
Message-ID: <20120419000842.GA24575@kroah.com>
References: <1332173578-27422-1-git-send-email-j-pihet@ti.com>
 <CAORVsuV-GJAabY49G0fOgcBcg-CNdpNiTE+AcBN07wrWZH3qcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAORVsuV-GJAabY49G0fOgcBcg-CNdpNiTE+AcBN07wrWZH3qcQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 10:04:22AM +0200, Jean Pihet wrote:
> Hi Andrew, Greg,
> 
> Can you please look at this patch set?
> The idea is to create a framework and drivers for the AVS class of
> devices. This patch set implements the first step by moving the
> existing code to drivers/power/avs. Next steps will be to implement
> class support and notifications, add more classes of operations for
> OMAP chips, etc.
> 
> Keerthy J is taking over the ownership of this code and will continue
> the development further.
> 
> What do you think?

I think Kevin and Rafael's comments need to be addressed.

greg k-h
