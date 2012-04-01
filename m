Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab2DATOY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 15:14:24 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:41985 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752918Ab2DATOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 15:14:23 -0400
Date: Sun, 1 Apr 2012 22:13:51 +0300
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: Joe Perches <joe@perches.com>
Cc: eduardo.valentin@ti.com, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Len Brown <len.brown@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH 17/76] thermal_sys: convert printks to
 pr_<level>
Message-ID: <20120401191351.GA4010@besouro>
Reply-To: eduardo.valentin@ti.com
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
 <c5a01dd52dc4903772f464ea580895ccc36e911d.1333101989.git.len.brown@intel.com>
 <20120330134119.GA13130@besouro>
 <1333134530.27601.2.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333134530.27601.2.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Joe,

On Fri, Mar 30, 2012 at 12:08:50PM -0700, Joe Perches wrote:
> On Fri, 2012-03-30 at 16:41 +0300, Eduardo Valentin wrote:
> > On Fri, Mar 30, 2012 at 06:13:20AM -0400, Len Brown wrote:
> > > From: Joe Perches <joe@perches.com>
> > > Use the current logging style.
> []
> > We should get the struct dev in thermal_zone_device, I think it makes
> > more sense to use the dev_* helper functions.
> []
> > The orig argument could probably be changed to a thermal zone device
> > and the we use it's id as orig for the message.
> > What do you think?
> 
> dev_<level> should be used instead of pr_<level> when
> an appropriate struct device * is available.

Agreed that we need a struct device *. My comments are based on the fact
that you have one of it inside the struct therma_zone_device, field device.

Isn't that struct device appropriated enough to be used by the dev_* functions?

> 
> cheers, Joe
> 

Cheers,

Eduardo
