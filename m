Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109Ab1CIPGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 10:06:35 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44251 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069Ab1CIPGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 10:06:32 -0500
Date: Wed, 9 Mar 2011 16:06:18 +0100
From: Borislav Petkov <bp@amd64.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Borislav Petkov <bp@alien8.de>, Arnd Bergmann <arnd@arndb.de>,
        Sam Ravnborg <sam@ravnborg.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "bp@amd64.org" <bp@amd64.org>
Subject: Re: [PATCH -v5] kbuild: Add extra gcc checks
Message-ID: <20110309150618.GA2368@aftab>
References: <20110301083529.GA767@liondog.tnic>
 <20110309144504.GA1096@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110309144504.GA1096@sepie.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 09:45:04AM -0500, Michal Marek wrote:
> On Tue, Mar 01, 2011 at 09:35:29AM +0100, Borislav Petkov wrote:
> > Add a 'W=1' Makefile switch which adds additional checking per build
> > object.
> > 
> > The idea behind this option is targeted at developers who, in the
> > process of writing their code, want to do the occasional
> > 
> > make W=1 [target.o]
> > 
> > and let gcc do more extensive code checking for them. Then, they
> > could eyeball the output for valid gcc warnings about various
> > bugs/discrepancies which are not reported during the normal build
> > process.
> > 
> > For more background information and a use case, read through this
> > thread: http://marc.info/?l=kernel-janitors&m=129802065918147&w=2
> > 
> > -v5: Document internal kbuild variable which is introduced by this.
> > Simplify assignment.
> 
> Thanks, applied to kbuild-2.6.git#packaging. If someone comes up with a
> good selection of warnings for W=1 and W=2, we can change it later.

Yeah, I was going to do that but am terribly busy at the moment. I'll do
an initial proposal against your kbuild branch when I get a chance.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
