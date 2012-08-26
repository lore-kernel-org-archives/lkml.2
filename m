Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab2HZMd7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 08:33:59 -0400
Received: from host-176-100-244-43.masterbit.su ([176.100.244.43]:43424 "EHLO
	tservice.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab2HZMd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 08:33:57 -0400
Date: Sun, 26 Aug 2012 16:33:54 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [REVIEW][PATCH 09/15] userns: Convert process event connector
 to handle kuids and kgids
Message-ID: <20120826123354.GA23803@ioremap.net>
References: <87lih2h6i4.fsf@xmission.com>
 <877gsmfrkc.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gsmfrkc.fsf@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 05:02:59PM -0700, Eric W. Biederman (ebiederm@xmission.com) wrote:
> 
> - Only allow asking for events from the initial user and pid namespace,
>   where we generate the events in.
> 
> - Convert kuids and kgids into the initial user namespace to report
>   them via the process event connector.


Looks good, if IDs are really supposed to be sent only from root
namespace. And you dropped PROC_EVENTS from init/Kconfig, but since it
was no, it should be ok by default.

Feel free to add my acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Although I thoughs it could be more interesting to generate events
including namespace id

-- 
	Evgeniy Polyakov
