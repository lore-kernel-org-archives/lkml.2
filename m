Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280Ab1D2AjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 20:39:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:37243 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab1D2Ai6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 20:38:58 -0400
Date: Fri, 29 Apr 2011 02:38:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH 2/2] x86: Change trap definitions to enumerated values
In-Reply-To: <1303513438-26519-2-git-send-email-vnagarnaik@google.com>
Message-ID: <alpine.LFD.2.02.1104290233490.3005@ionos>
References: <1303513438-26519-1-git-send-email-vnagarnaik@google.com> <1303513438-26519-2-git-send-email-vnagarnaik@google.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Apr 2011, Vaibhav Nagarnaik wrote:

> From: Aditya Kali <adityakali@google.com>
> 
> The traps are referred to by their numbers and it can be difficult to
> understand them while reading the code without context. This patch adds
> enumeration of the trap numbers and replaced the numbers to the correct
> enum for x86.

I really like that patch, but it should have been 1/2 as it has a
value independent of the trap trace stuff.

And if you had done that, then the trap trace patch could have used
those symbols instead of the numbers as well.

Now that's the 2/2 patch and leaves the (not so) shiny new trace
points with those weird numbers. :(

Thanks,

	tglx
