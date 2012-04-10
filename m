Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309Ab2DJVD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 17:03:27 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:40641 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab2DJVD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 17:03:26 -0400
Date: Tue, 10 Apr 2012 23:03:14 +0200
From: Borislav Petkov <bp@amd64.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Michal Marek <mmarek@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH v4 2/4] tools: Add a toplevel Makefile
Message-ID: <20120410210314.GC30366@aftab>
References: <1334071240-28692-1-git-send-email-bp@amd64.org>
 <1334071240-28692-3-git-send-email-bp@amd64.org>
 <20120410203348.GB28293@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120410203348.GB28293@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 10:33:48PM +0200, Sam Ravnborg wrote:
> Things would be much simpler is all tools were adjusted to:
> a) the subdir they live in is the make target name
> b) each tool has three mandatory targets:
>  1) default target => build the tool
>  2) clean
>  3) install
> 
> I can see that with the layout today you cannot
> distingush between the various targets below power.
> But the current solutions is not scaleable nor maintainable.
> 
> Even if you cannot fix power/* then testing looks easy.
> 
> But all that can always to improved and consolidated later.

Right, I was deliberating on whether to unify the dir layout so that it
fits with the Makefile targets nicely but decided to leave it out for
later. IOW, do the "one thing at a time" deal. Besides, some tools don't
have that clearly defined targets and selftests, for example, doesn't
need to be installed but simply run in a loop.

So definitely agreed, the tools/ dir could use a bunch of cultivating in
later cycles.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
