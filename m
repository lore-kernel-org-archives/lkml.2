Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab1D2PCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:02:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:47314 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817Ab1D2PCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:02:22 -0400
Date: Fri, 29 Apr 2011 17:02:19 +0200
From: Michal Marek <mmarek@suse.cz>
To: Dave Jones <davej@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
        David Daney <ddaney@caviumnetworks.com>, Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        BorislavPetkov <bp@alien8.de>
Subject: Re: annoying new gcc 4.6.0 warnings.
Message-ID: <20110429150219.GA22912@sepie.suse.cz>
References: <BANLkTi=srdq69ZG8pWbzWOZLX5KX48DcbQ@mail.gmail.com>
 <4DB087EC.1010205@caviumnetworks.com>
 <1303415086.24766.84.camel@Joe-Laptop>
 <20110421195801.GA15126@redhat.com>
 <20110421200836.GA31709@merkur.ravnborg.org>
 <20110421202713.GA19425@redhat.com>
 <4DB09590.1040709@caviumnetworks.com>
 <20110421204549.GA20508@redhat.com>
 <20110421205612.GA4541@merkur.ravnborg.org>
 <20110421212812.GA26680@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110421212812.GA26680@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 05:28:13PM -0400, Dave Jones wrote:
> Disable the new -Wunused-but-set-variable that was added in gcc 4.6.0
> It produces more false positives than useful warnings.
>  
> This can still be enabled using W=1
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>
> Tested-by: Sam Ravnborg <sam@ravnborg.org>

Applied to kbuild-2.6.git#kbuild, thanks.

Michal
