Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab2KZOmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 09:42:00 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:33741 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab2KZOl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 09:41:59 -0500
Date: Mon, 26 Nov 2012 18:41:55 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Amnon Shiloh <u3557@miso.sublimeip.com>
Cc: Andrey Wagin <avagin@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: vdso && cr
Message-ID: <20121126144155.GA16404@moon>
References: <20121126141843.GE10312@moon>
 <20121126142655.9AD28592064@miso.sublimeip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121126142655.9AD28592064@miso.sublimeip.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 01:26:55AM +1100, Amnon Shiloh wrote:
> Programmers don't (and the manual-page says they shouldn't even try)
> call "sigreturn" directly.
> 
> If an interrupt happens, by bad luck, to occur while the process
> is running vdso code, then eventually, once signal-processing is
> complete, "sigreturn" (issued by  glibc) will take the process back
> to where it was before the interrupt happend, inside the vdso page.

Hi Amnon, good point, need to think. Frankly I would like to escape
kernel patching as long as possible ;)
