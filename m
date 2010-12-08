Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab0LHOsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 09:48:22 -0500
Received: from canuck.infradead.org ([134.117.69.58]:55815 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab0LHOsV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 09:48:21 -0500
Subject: Re: perf hw  in kexeced kernel broken in tip
From: Peter Zijlstra <peterz@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haren Myneni <hbabu@us.ibm.com>
In-Reply-To: <20101208144245.GB31703@redhat.com>
References: <1291232989.32004.1987.camel@laptop>
	 <20101201195835.GE2511@redhat.com> <1291234036.32004.2008.camel@laptop>
	 <m162vdp3l4.fsf@fess.ebiederm.org> <20101202052321.GH18100@redhat.com>
	 <1291275270.4023.20.camel@twins> <20101202161502.GL18100@redhat.com>
	 <1291764620.2032.1293.camel@laptop> <20101208140103.GM21786@redhat.com>
	 <1291818005.28378.38.camel@laptop>  <20101208144245.GB31703@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 08 Dec 2010 15:48:04 +0100
Message-ID: <1291819684.28378.70.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 09:42 -0500, Vivek Goyal wrote:
> 
> Either driver itself can detect that device is in inconsistent state and
> reset it otherwise we also pass a command line parameter "reset_devices" to
> second kernel to explicitly tell kernel that devices might be in bad state,
> reset these during initialization. If we want to use these perf counters in
> kdump kernel, we shall have to do something similar.

Right, so I'm perfectly fine with leaving the kdump kernel broken for
now and if people really do need hardware events we can try and reset
the hardware when we find that reset_devices command line parameter.

Not sure how that interacts with these broken BIOSes, but its kdump so
its mostly broken by design anyway ;-)


