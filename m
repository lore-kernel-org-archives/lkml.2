Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760014Ab1D0UqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 16:46:12 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:53098 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759979Ab1D0UqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 16:46:08 -0400
Date: Wed, 27 Apr 2011 22:46:07 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Joe Perches <joe@perches.com>
Cc: Borislav Petkov <bp@alien8.de>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v3.2] kbuild: implement several W= levels
Message-ID: <20110427204607.GA9005@merkur.ravnborg.org>
References: <20110427113513.GB18112@eferding.osrc.amd.com> <1303935327-5154-1-git-send-email-bp@alien8.de> <1303935660.24299.76.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303935660.24299.76.camel@Joe-Laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 01:21:00PM -0700, Joe Perches wrote:
> On Wed, 2011-04-27 at 22:15 +0200, Borislav Petkov wrote:
> > From: Sam Ravnborg <sam@ravnborg.org>
> []
> > +warning-1 += -Wold-style-definition
> > +warning-1 += $(call cc-option, -Wmissing-include-dirs)
> 
> Only thing I would suggest is a comment describing why
> some entries use $(call cc-option, -Wfoo) and others don't.
> 
> Something akin to:
> 
> # Use call cc-option when the minimum supported gcc version does not
> # support a specific option but a later gcc version does.

>From the patch:
+# $(call cc-option, -W...) handles gcc -W.. options which
 # are not supported by all versions of the compiler

So it is already included.

	Sam
