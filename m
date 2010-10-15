Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461Ab0JOWfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 18:35:09 -0400
Received: from kroah.org ([198.145.64.141]:48802 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255Ab0JOWfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 18:35:07 -0400
Date: Fri, 15 Oct 2010 15:35:01 -0700
From: Greg KH <greg@kroah.com>
To: Erik Gilling <konkers@google.com>
Cc: achew@nvidia.com, jmayo@nvidia.com, a.zummo@towertech.it, olof@lixom.net,
        mcuos.com@gmail.com, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, rtc-linux@googlegroups.com
Subject: Re: [PATCH 1/1 V2] rtc: Add real-time clock driver for Tegra.
Message-ID: <20101015223501.GA18609@kroah.com>
References: <1287089791-25673-1-git-send-email-achew@nvidia.com>
 <AANLkTim1LQ5xE9fxT9JgKb4a7AKsnRF+3daHcSGBKK4O@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim1LQ5xE9fxT9JgKb4a7AKsnRF+3daHcSGBKK4O@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 03:12:47PM -0700, Erik Gilling wrote:
> > --- /dev/null
> > +++ b/drivers/rtc/rtc-tegra.c
> > @@ -0,0 +1,509 @@
> > +/*
> > + * An RTC driver for the NVIDIA Tegra 200 series internal RTC.
> > + *
> > + * Copyright (c) 2010, NVIDIA Corporation.
> > + * Copyright (c) 2010 Jon Mayo <jmayo@nvidia.com>
> 
> This is kinda odd.  Usually when doing work on behalf of the company
> you work for, the code is (c) the company.  Consider changing Jon's
> line to "Author: Jon Mayo <jmayo@nvidia.com>"

Woah, are you sure?  Some companies, and countries, allow/require dual
copyright.  The only one who can change this for sure is Jon, not anyone
else.

thanks,

greg 'I work for such a company' k-h
