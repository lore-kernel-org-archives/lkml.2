Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760445Ab0KRVCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:02:07 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36782 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759479Ab0KRVCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:02:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bKTgI5fvIFcloggAkGY5+gEmoB8oP8Pbp9BnXDh4iK8JmYpgFxeMwbKqrgw14gpDcv
         YCPT7Ny0GTos/o8leZD8X6sb6IVMHZ1kj2fgiU3ceL8WVZuJjJ/cItxQmbW2/RJa5R7R
         5P+Mrdhn5DiUFGRa4WSri69a/M/NzcmjQx5BU=
Date: Fri, 19 Nov 2010 00:01:59 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
Message-ID: <20101118210159.GF6028@lenovo>
References: <20101116184325.GB4823@redhat.com> <4CE2E3C3.6060800@windriver.com> <20101118080516.GJ32621@elte.hu> <4CE52048.5080802@windriver.com> <1290086232.2109.1507.camel@laptop> <20101118193247.GF18100@redhat.com> <4CE583D0.8050407@windriver.com> <20101118200807.GC8131@redhat.com> <20101118201118.GC6028@lenovo> <20101118205203.GA11445@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118205203.GA11445@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 03:52:03PM -0500, Don Zickus wrote:
...
> > 
> > ok, Don, but you mentioned there are false alarms on real P4 machine, right?
> 
> Yeah, there are two problems.  One is using kgdb tests on kvm guests.  The
> other is using kgdb tests on a bare metal p4 machine.
> 
> Cheers,
> Don
>

 ok, thanks, Jason just confirmed it too. I thing if we run with kgdb armed
it (kgdb) should obtain nmi handler first and perf only after.

 actually I'm not sure why p4 hangs here while core passes the test, most
probably due to hardware reason.
 
  Cyrill
