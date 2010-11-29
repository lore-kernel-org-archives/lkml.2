Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab0K2Sm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 13:42:29 -0500
Received: from claranet-outbound-smtp04.uk.clara.net ([195.8.89.37]:55816 "EHLO
	claranet-outbound-smtp04.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751233Ab0K2Sm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 13:42:28 -0500
Message-ID: <4CF3F40E.3040508@sciolus.org>
Date: Mon, 29 Nov 2010 18:42:22 +0000
From: "R.M. Thomas" <rmthomas@sciolus.org>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: easycap: fix build failure
References: <alpine.LNX.2.00.1011291813060.981@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1011291813060.981@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> Now, I really believe that this driver is completely hopeless and the only 
> option is complete from-scratch rewrite. I have been looking into it for 
> approximately ~30 seconds (solely to fix this build failure), and I really 
> don't know what to say.

You are quite right of course.  This driver does indeed require a complete
re-write.  The non-standard formatting and (now) redundant debugging macros
are actually the least troublesome issues.  More significant is the need to
replace most of the routines by existing functions from the V4L subsystem.
Unfortunately I shall be unable to undertake this essential work myself in
the foreseeable future owing to other commitments.  Probably the simplest
solution would be to drop the driver from staging.

Even in its present untidy state the driver does work reasonably well on x86
and x86-64, so something could possibly be salvaged from it.

Mike   

