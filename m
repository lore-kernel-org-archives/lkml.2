Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab1DVKUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 06:20:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39258 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194Ab1DVKUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 06:20:31 -0400
Date: Fri, 22 Apr 2011 12:20:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] kbuild: implement several W= levels
Message-ID: <20110422102028.GA8324@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
	linux-kbuild <linux-kbuild@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <20110421213903.GB9660@merkur.ravnborg.org>
 <20110422081926.GA26286@liondog.tnic>
 <20110422101524.GA20671@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110422101524.GA20671@merkur.ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

On Fri, Apr 22, 2011 at 12:15:24PM +0200, Sam Ravnborg wrote:
> Hi Borislav.
>  
> > > the patch is only an RFC - and is not made on top
> > > of an upstream kernel with no additiona stuff applied.
> > 
> > Thanks for doing this, a couple of suggestions below.
> ...
> 
> You already spend more time analysing this than it took me
> to write the patch.
> Can I persuade you to implement the various W= levels based
> on your analysis and send to Michal for merging?
> You can use my v2 PATCH as inspiration.
> 
> Please take authorship on the patch as the main work
> is to decide what warnings belongs to which level.
> 
> [Snipped - lots of good comments]

thanks but according to Documentation/SubmittingPatches, the _initial_
author is the author of the patch. Besides, I just had the talk with
Ingo the other day on how to acknowledge multuple authors so I'm not
making the same mistake again :).

But seriously, let me add my comments to your patch while they're fresh
in my head and let's see what we come up with in our combined and
perfectly orchestrated effort :).

Thanks.

-- 
Regards/Gruss,
    Boris.
