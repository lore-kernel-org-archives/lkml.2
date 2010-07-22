Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab0GVPwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 11:52:30 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:61333 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab0GVPw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 11:52:28 -0400
Date: Thu, 22 Jul 2010 11:52:02 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Jack Steiner <steiner@sgi.com>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] - Mapping ACPI tables as CACHED
In-reply-to: <20100722152220.GA18290@sgi.com>
Message-id: <alpine.LFD.2.00.1007221150360.3164@localhost.localdomain>
References: <20100722152220.GA18290@sgi.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The following experimental patch changes the kernel mapping for ACPI tables
> to CACHED. This eliminates the page attibute conflict & allows users to map
> the tables CACHEABLE. This significantly speeds up boot:
> 
> 	38 minutes without the patch
> 	27 minutes with the patch
> 		~30% improvement
> 
> Time to run ACPIDUMP on a large system:
> 	527 seconds without the patch
> 	  8 seconds with the patch

Interesting.

Can you detect a performance differene on a 1-node machine
that doesn't magnify the penalty of the remote uncached access?

thanks,
-Len Brown, Intel Open Source Technology Cetner

