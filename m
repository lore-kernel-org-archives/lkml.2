Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab2HBNc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 09:32:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44555 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154Ab2HBNcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 09:32:54 -0400
Date: Thu, 2 Aug 2012 15:32:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Benjamin Poirier <bpoirier@suse.de>
Cc: Borislav Petkov <borislav.petkov@amd.com>, Michal Marek <mmarek@suse.cz>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 0/6] menuconfig: jump to search results
Message-ID: <20120802133252.GA3752@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Benjamin Poirier <bpoirier@suse.de>,
	Borislav Petkov <borislav.petkov@amd.com>,
	Michal Marek <mmarek@suse.cz>,
	Lucas De Marchi <lucas.demarchi@profusion.mobi>,
	Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
References: <1343676130-29770-1-git-send-email-bpoirier@suse.de>
 <20120730195826.GA8242@liondog.tnic>
 <20120730202212.GA31790@d2.synalogic.ca>
 <20120731075751.GB23595@liondog.tnic>
 <20120731131751.GA10910@d2.synalogic.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120731131751.GA10910@d2.synalogic.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 09:17:51AM -0400, Benjamin Poirier wrote:
> > * when searching for "DELAY" for example, I get results without numbers
> > to which I can't jump to:
> > 
> > ...
> >   │ Symbol: DEFAULT_IO_DELAY_TYPE [=0]
> >   │ Type  : integer
> >   │
> >   │
> >   │ Symbol: IO_DELAY_TYPE_0X80 [=0]
> >   │ Type  : integer
> > ...
> > 
> > maybe because they don't have "---help---" section?
> 
> Because they don't have a prompt - they don't appear in any menu at all.
> In that case there's nowhere to jump to. That's why those symbols don't
> get a number.

Right, so how about you don't show them at all then?

-- 
Regards/Gruss,
Boris.
