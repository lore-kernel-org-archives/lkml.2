Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab2KWRpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 12:45:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020Ab2KWRpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 12:45:22 -0500
Date: Fri, 23 Nov 2012 18:45:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Amnon Shiloh <u3557@miso.sublimeip.com>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: vdso && cr (Was: arch_check_bp_in_kernelspace: fix the range
Message-ID: <20121123174529.GB3361@redhat.com>
References: <50AE91AD.1090709@parallels.com> <20121123002021.9A78159206F@miso.sublimeip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121123002021.9A78159206F@miso.sublimeip.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amnon,

I am going to "ignore" this thread because this is not my area and
I can't help anyway. Just one note:

On 11/23, Amnon Shiloh wrote:
>
> The solution can be to hold all catched signals while in the VDSO page.
> ...
>
> 1) + introduce a kernel feature to prevent
>    catching signals within the VDSO page (probably a new prctl,
>    or make it the default)

Sorry, never ;)

Oleg.

