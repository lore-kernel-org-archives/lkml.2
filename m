Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964907Ab2EaUR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 16:17:59 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:45155 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964860Ab2EaUR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 16:17:57 -0400
Date: Thu, 31 May 2012 22:18:24 +0200
From: Borislav Petkov <bp@amd64.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
Message-ID: <20120531201824.GD16998@aftab.osrc.amd.com>
References: <20120531142229.GF14515@aftab.osrc.amd.com>
 <4FC783EA.80704@redhat.com>
 <20120531145416.GI14515@aftab.osrc.amd.com>
 <4FC787BF.3020006@redhat.com>
 <20120531151408.GJ14515@aftab.osrc.amd.com>
 <4FC798E2.4000402@redhat.com>
 <20120531171337.GN14515@aftab.osrc.amd.com>
 <1338492772.13348.388.camel@gandalf.stny.rr.com>
 <20120531194207.GC16998@aftab.osrc.amd.com>
 <1338495092.13348.419.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338495092.13348.419.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 04:11:32PM -0400, Steven Rostedt wrote:
> Sure, but how noisy is EDAC? Does it actually fill up the ring
> buffers?

It could be very quiet (i.e., machine runs with no errors) and it could
have bursts where it reports a large number of errors back-to-back
depending on access patterns, DIMM health, temperature, sea level and at
least a bunch more factors.

So I can imagine buffers filling up suddenly and fast, and userspace
having hard time consuming them in a timely manner.

Every byte counts in such cases.


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
