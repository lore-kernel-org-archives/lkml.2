Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab2GaH54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 03:57:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48470 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623Ab2GaH5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 03:57:54 -0400
Date: Tue, 31 Jul 2012 09:57:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: Benjamin Poirier <bpoirier@suse.de>
Cc: Michal Marek <mmarek@suse.cz>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 0/6] menuconfig: jump to search results
Message-ID: <20120731075751.GB23595@liondog.tnic>
Reply-To: Borislav Petkov <borislav.petkov@amd.com>
Mail-Followup-To: Borislav Petkov <borislav.petkov@amd.com>,
	Benjamin Poirier <bpoirier@suse.de>, Michal Marek <mmarek@suse.cz>,
	Lucas De Marchi <lucas.demarchi@profusion.mobi>,
	Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
References: <1343676130-29770-1-git-send-email-bpoirier@suse.de>
 <20120730195826.GA8242@liondog.tnic>
 <20120730202212.GA31790@d2.synalogic.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120730202212.GA31790@d2.synalogic.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 04:22:12PM -0400, Benjamin Poirier wrote:
> It's against linux-next, which already contains some patches for
> menuconfig.

Ok, applying against the linux-next from today succeeds. And they seem
to work, I can search for CONFIG_* stuff and then go straight to the
results.

A couple more observations:

* The numbering in the search results looks kinda strange and
non-intuitive IMHO. Would it be possible to use the ncurses cursor to
iterate over the search results like one does in the normal menus? I.e.,
the horizontal bar which highlights the item with the background color
or whatever - can it be moved up and down with the arrow keys through
the search results too?

* when searching for "DELAY" for example, I get results without numbers
to which I can't jump to:

...
  │ Symbol: DEFAULT_IO_DELAY_TYPE [=0]
  │ Type  : integer
  │
  │
  │ Symbol: IO_DELAY_TYPE_0X80 [=0]
  │ Type  : integer
...

maybe because they don't have "---help---" section?

In those cases, you probably want to hide those from the search results?

Other than that it looks good and I'd say we need more menuconfig
functionality like that which eases/speeds up working with that thing :).

Thanks.

-- 
Regards/Gruss,
    Boris.
