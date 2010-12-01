Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab0LAVfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 16:35:19 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48242 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab0LAVfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 16:35:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JZ4ybSHPWpqBMScrzTAWw1kxWo6KNyRiiUYhaRXqAMEB6aMe7946jHaYu7rpYpXItK
         dIULFAPQEeORc36mmQd57GeUfa3PVFHUGGKhsNd6wPmPsUEGd/TYNtuvP4oAIrHUk7xk
         0UIeBRWGx2l0NEcn/4sHNl6tOS+OWZORAmGt0=
Date: Thu, 2 Dec 2010 00:35:14 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/9] x86, NMI: Remove DIE_NMI_IPI and add priorties to
	handlers
Message-ID: <20101201213513.GD6478@lenovo>
References: <1291156050-4482-1-git-send-email-dzickus@redhat.com> <1291156050-4482-5-git-send-email-dzickus@redhat.com> <20101201184128.GB6478@lenovo> <20101201213034.GD7218@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101201213034.GD7218@basil.fritz.box>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 10:30:34PM +0100, Andi Kleen wrote:
> On Wed, Dec 01, 2010 at 09:41:28PM +0300, Cyrill Gorcunov wrote:
> > On Tue, Nov 30, 2010 at 05:27:25PM -0500, Don Zickus wrote:
> > > When re-ordering how the NMI handles its callbacks, a conversation started
> > > asking what DIE_NMI_IPI meant.  No one could answer it.
> > 
...
> > Andi do you remember what the initial idea was? Didn't find any user of it
> > even in this old commit. Just curious.
> 
> The original die names were pretty much a 1:1 conversion of the hooks
> used by both the external KDB and KGDB patchkits floating around
> at that time.
> 
> IIRC DIE_NMI_IPI was the one that was early in the NMI handler
> and DIE_NMI late when everything else failed.
> 
> So you could use NMI_IPI when you just wanted to stop
> all CPUs with a broadcast NMI and can check that reliable
> through some memory location, and NMI when you wanted
> to drop into the debugger as a last resort.
> 
> 
> -Andi
>

Thanks for info Andi, good to know.
 
  Cyrill
