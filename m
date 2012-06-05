Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab2FERI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 13:08:58 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:37555 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab2FERI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 13:08:57 -0400
Date: Tue, 5 Jun 2012 19:09:21 +0200
From: Borislav Petkov <bp@amd64.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@amd64.org>, Christopher Yeoh <cyeoh@au1.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] CMA: Do no enable it by default
Message-ID: <20120605170921.GO13495@aftab.osrc.amd.com>
References: <20120531153512.GK14515@aftab.osrc.amd.com>
 <20120531154224.GL14515@aftab.osrc.amd.com>
 <20120601110647.2c446aa7@rockpopper>
 <20120605110541.GC13495@aftab.osrc.amd.com>
 <CA+55aFxu9ZfbKuWdhmADreRS9wxzMyW9buoVkd=B4Yqi=bxbiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxu9ZfbKuWdhmADreRS9wxzMyW9buoVkd=B4Yqi=bxbiw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 09:46:49AM -0700, Linus Torvalds wrote:
> On Tue, Jun 5, 2012 at 4:05 AM, Borislav Petkov <bp@amd64.org> wrote:
> >
> > Besides, in the config option it says "... which allow a process with
> > the correct privileges to directly read from or write to to another
> > process's address space.", which, if the reading process has somehow
> > gained privileges (as that never happens) is your security issue right
> > there.
> 
> What?
> 
> It's using the same privileges as ptrace. If you are allowed to ptrace
> somebody, there's no security issue.

It didn't sound to me like that from the text - to my paranoid mind this
sounds like some process reading or writing some other process' address
space and changing stuff arbitrarily.

Maybe the text should be made more soothing so that no alarms go off
while reading it :-).

> Also, the reason it's "default y" is that the feature actually made it
> in earlier (with no config option at all).

I know, and it shouldn've been but it's too late now.

> Now, I certainly agree that we could turn it off by default since
> it's not that common, but at the same time none of your actual commit
> comments make sense, so that would have to be fixed first.

Sure, will do.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
