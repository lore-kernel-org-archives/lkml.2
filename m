Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab0LHPPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 10:15:31 -0500
Received: from canuck.infradead.org ([134.117.69.58]:51239 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab0LHPP3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 10:15:29 -0500
Subject: Re: perf hw  in kexeced kernel broken in tip
From: Peter Zijlstra <peterz@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haren Myneni <hbabu@us.ibm.com>
In-Reply-To: <20101208150243.GC31703@redhat.com>
References: <1291234036.32004.2008.camel@laptop>
	 <m162vdp3l4.fsf@fess.ebiederm.org> <20101202052321.GH18100@redhat.com>
	 <1291275270.4023.20.camel@twins> <20101202161502.GL18100@redhat.com>
	 <1291764620.2032.1293.camel@laptop> <20101208140103.GM21786@redhat.com>
	 <1291818005.28378.38.camel@laptop> <20101208144245.GB31703@redhat.com>
	 <1291819684.28378.70.camel@laptop>  <20101208150243.GC31703@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 08 Dec 2010 16:15:07 +0100
Message-ID: <1291821307.28378.93.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 10:02 -0500, Vivek Goyal wrote:

> >but its kdump so its mostly broken by design anyway ;-)
> 
> Kdump has its share of problems especially with the fact that
> kernel/drivers find devices in bad state and are not hardened enough
> to deal with that. But on bare metal what's the better way of capturing
> kernel crash dump? Trying to do anything post crash in the kernel is
> also not very reliable either.

/me <3 RS-232

I haven't found anything better than that... 

And poking at the RS-232 requires less of the kernel to be functional
than booting into a new kernel (whose image might have been corrupted by
the dying kernel, etc..)
