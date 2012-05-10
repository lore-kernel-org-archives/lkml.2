Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab2EJNlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 09:41:51 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:55671 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758608Ab2EJNlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 09:41:49 -0400
Date: Thu, 10 May 2012 15:41:36 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Tony Luck <tony.luck@intel.com>
Subject: Re: [EDAC ABI v13 04/25] events/hw_event: Create a Hardware Events
 Report Mecanism (HERM)
Message-ID: <20120510134136.GC31257@aftab.osrc.amd.com>
References: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
 <1334608729-30803-5-git-send-email-mchehab@redhat.com>
 <20120509121326.GA22737@aftab.osrc.amd.com>
 <4FAA6802.9070506@redhat.com>
 <20120509132237.GD22737@aftab.osrc.amd.com>
 <4FAA7649.5080606@redhat.com>
 <20120509140632.GG22737@aftab.osrc.amd.com>
 <4FAA7C1A.3020406@redhat.com>
 <20120509142456.GH22737@aftab.osrc.amd.com>
 <4FABBFAF.20809@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FABBFAF.20809@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 10:16:31AM -0300, Mauro Carvalho Chehab wrote:
> Nah, this is not marketing speak. HERM is not a trademark. amd64_edac,
> on the other hand, is using a trademark on his name. If we use your
> logic, this would need to be renamed to something else, to avoid using
> a "marketing speak".

I'm not even going to dignify that with an answer because it is a bunch
of bullshit and you know it.

> We need some name to differentiate between the broken EDAC core where
> modern memory controllers are not properly represented and reports
> errors on fake csrows/channels from the EDAC+HERM core that will
> properly provide the error information to where it really belongs.

A kernel version or a commit id is not enough here I guess.

> In other words, HERM is just an acronym[1] to the version to point to
> where EDAC starts to work fine with modern memory controllers.

Seems to me you're desperately trying to prove your point for having
this HERM thing by coming up with a bunch of bogus arguments.

And I'm still waiting for a real, technical reason which legitimizes
calling a tracepoint something special.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
