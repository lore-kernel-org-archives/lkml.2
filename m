Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab1AQScM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 13:32:12 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14567 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab1AQScK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 13:32:10 -0500
Date: Mon, 17 Jan 2011 19:32:10 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Len Brown <lenb@kernel.org>
cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH] ACPI: Fix memory leak in
 acpi_ev_asynch_execute_gpe_method().
In-Reply-To: <alpine.LFD.2.02.1101162313220.3244@x980>
Message-ID: <alpine.LNX.2.00.1101171931420.27021@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101162033531.13377@swampdragon.chaosbits.net> <alpine.LFD.2.02.1101162313220.3244@x980>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Jan 2011, Len Brown wrote:

> Looks like this bug was added by 
> 5a284cd75d635e3c5db0210dc9a9a44c6839f460
> (ACPICA: Fix local variable mess in acpi_ev_asynch_execute_gpe_method).
> 
> The good news is that it is new in 2.6.38-merge
> Also, I doubt that these error cases actually
> occur in any significant frequency in practice.
> 
> Thanks for the find.
> 
You're welcome. Can I assume that you'll merge it and push it up-stream 
from here?

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

