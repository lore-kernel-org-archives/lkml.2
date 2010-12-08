Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab0LHT3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 14:29:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab0LHT3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 14:29:10 -0500
Date: Wed, 8 Dec 2010 14:01:58 -0500
From: Don Zickus <dzickus@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haren Myneni <hbabu@us.ibm.com>
Subject: Re: perf hw  in kexeced kernel broken in tip
Message-ID: <20101208190158.GA8565@redhat.com>
References: <1291234036.32004.2008.camel@laptop>
 <m162vdp3l4.fsf@fess.ebiederm.org>
 <20101202052321.GH18100@redhat.com>
 <1291275270.4023.20.camel@twins>
 <20101202161502.GL18100@redhat.com>
 <1291764620.2032.1293.camel@laptop>
 <20101208140103.GM21786@redhat.com>
 <1291818005.28378.38.camel@laptop>
 <1291820356.28378.83.camel@laptop>
 <4CFFD1C2.1080108@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CFFD1C2.1080108@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 10:43:14AM -0800, Yinghai Lu wrote:
> 
> can you add sth force_... in command line to take over ownership of perf from BIOS or previous kernel ?
> 
> then still can use perf etc after we kexec from RHEL or SLES kernel to later kernel ( from 2.6.37)

My understand is that you can't because the BIOS is actively using it
behind the scenes of the kernel (well during an SMI).  I have a machine
where I tried to force take it but it still stopped triggering interrupts.

Cheers,
Don
