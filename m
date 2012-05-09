Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab2EIHYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 03:24:23 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57319 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753025Ab2EIHYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 03:24:22 -0400
Date: Wed, 9 May 2012 09:24:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bojan Smojver <bojan@rexursive.com>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: In kernel hibernation, suspend to both: draft
Message-ID: <20120509072418.GC19853@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Bojan Smojver <bojan@rexursive.com>,
	Linux PM list <linux-pm@vger.kernel.org>,
	linux-kernel@vger.kernel.org
References: <1336379825.2097.5.camel@shrek.rexursive.com>
 <201205072214.13912.rjw@sisk.pl>
 <1336446956.2097.16.camel@shrek.rexursive.com>
 <201205082326.42970.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201205082326.42970.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 11:26:42PM +0200, Rafael J. Wysocki wrote:
> On Tuesday, May 08, 2012, Bojan Smojver wrote:
> > On Mon, 2012-05-07 at 22:14 +0200, Rafael J. Wysocki wrote:
> > > Looks reasonable at first sight.
> > 
> > OK, thanks for having a look! I'll check to see whether memory for
> > hibernation is been released properly and then I may submit this for
> > real. BTW, the patch actually worked on my ThinkPad T510. The miracles
> > never stop. :-)
> > 
> > Just to be sure - I should prepare a patch against your linux-next
> > branch, correct?
> 
> Yup.

Oh goody, that's what the apples do - suspend to ram and disk. When you
have the patch ready, you'll have another tester, just send it on my way
too pls :-).

Thanks.

-- 
Regards/Gruss,
    Boris.
