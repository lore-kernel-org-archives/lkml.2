Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab2DYP2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 11:28:08 -0400
Received: from mail.windriver.com ([147.11.1.11]:34871 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab2DYP2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 11:28:07 -0400
Message-ID: <4F9817E8.7030700@windriver.com>
Date: Wed, 25 Apr 2012 10:27:36 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH v2] kgdb: Do not allow function tracing of kgdb code
References: <1335367432.28106.167.camel@gandalf.stny.rr.com>
In-Reply-To: <1335367432.28106.167.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 10:23 AM, Steven Rostedt wrote:
> As function tracing the kgdb code can cause issues, as kgdb is a
> debugger itself, do not trace the kgdb functions.
>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

You beat me to creating the patch, because I was in the process of
testing the same modification before posting. :-)

Acked-by: Jason Wessel <jason.wessel@windriver.com>

Thanks,
Jason.

