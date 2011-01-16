Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab1APTva (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 14:51:30 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:16052 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab1APTv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 14:51:29 -0500
Date: Sun, 16 Jan 2011 20:51:27 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH] ACPI: Fix memory leak in
 acpi_ev_asynch_execute_gpe_method().
In-Reply-To: <201101162048.29781.rjw@sisk.pl>
Message-ID: <alpine.LNX.2.00.1101162050532.13377@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101162033531.13377@swampdragon.chaosbits.net> <201101162048.29781.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Jan 2011, Rafael J. Wysocki wrote:

> On Sunday, January 16, 2011, Jesper Juhl wrote:
> > We will leak the memory allocated to 'local_gpe_event_info' if 
> > 'acpi_ut_acquire_mutex()' fails or if 'acpi_ev_valid_gpe_event()' fails in 
> > drivers/acpi/acpica/evgpe.c::acpi_ev_asynch_execute_gpe_method().
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> 
> Good catch!  How did you find it?
> 

This one was found with the help of Coverity prevent.


> Reviewed-by: Rafael Wysocki <rjw@sisk.pl>
> 
> Len, please apply and push to Linus ASAP.
> 
> Thanks,
> Rafael
> 

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

