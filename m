Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab2KZOSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 09:18:48 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:33786 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab2KZOSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 09:18:47 -0500
Date: Mon, 26 Nov 2012 18:18:43 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Amnon Shiloh <u3557@miso.sublimeip.com>
Cc: Andrey Wagin <avagin@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: vdso && cr (Was: arch_check_bp_in_kernelspace: fix the range
 check)
Message-ID: <20121126141843.GE10312@moon>
References: <CANaxB-yCSrUMQbjrZPMoHp0hN+uUuRDCW6yRazFYX1YR_di9dQ@mail.gmail.com>
 <20121126125502.0FDDD592064@miso.sublimeip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121126125502.0FDDD592064@miso.sublimeip.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 11:55:01PM +1100, Amnon Shiloh wrote:
> 
> You could of course keep that old code and modify only the very
> first instruction of each routine into a jump instruction, but then
> the code to which the process returns may not be compatible with
> the new kernel and/or hardware configuration.

For sure there will be some limitations but I fear we can't do
that much with it. I don't expect the regular program to use
sigreturn for jumping into vdso code, but I could be wrong.

	Cyrill
