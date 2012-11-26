Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab2KZJoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 04:44:09 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:50478 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab2KZJoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 04:44:07 -0500
Date: Mon, 26 Nov 2012 13:44:03 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>, Amnon Shiloh <u3557@miso.sublimeip.com>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrey Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: vdso && cr (Was: arch_check_bp_in_kernelspace: fix the range
 check)
Message-ID: <20121126094403.GB10312@moon>
References: <20121121141627.GB21030@redhat.com>
 <20121121173043.F0319592076@miso.sublimeip.com>
 <20121122161238.GA27078@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121122161238.GA27078@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 05:12:38PM +0100, Oleg Nesterov wrote:
> On 11/22, Amnon Shiloh wrote:
> >
> > Now however, that "vsyscall" was effectively replaced by vdso, it
> > creates a new problem for me and probably for anyone else who uses
> > some form of checkpoint/restore:
> 
> Oh, sorry, I can't help here. I can only add Cyrill and Pavel, they
> seem to enjoy trying to solve the c/r problems.

Hi Oleg, Amnon, sorry for delay on this message. First of all, I'm
not vDSO specialist but as to c/r aspect of it I've had in mind the
the following scenario: we dump vDSO area either complete euther simply
remember the functions addresses it provides, then on restore we replace
the functions prologue with jmp instruction which would point to the
vDSO entries provided us by a kernel. But again, I didn't spend much time
for vDSO yet.

	Cyrill
