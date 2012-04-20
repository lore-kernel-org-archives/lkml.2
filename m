Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab2DTO70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 10:59:26 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:24415 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab2DTO7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 10:59:21 -0400
Date: Fri, 20 Apr 2012 16:59:20 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, Andrew Morton <akpm@linux-foundation.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH v1 1/5] scripts: Add sortextable to sort the kernel's
	exception table.
Message-ID: <20120420145920.GA2891@merkur.ravnborg.org>
References: <1334872799-14589-1-git-send-email-ddaney.cavm@gmail.com> <1334872799-14589-2-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334872799-14589-2-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 02:59:55PM -0700, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
> 
> Using this build-time sort saves time booting as we don't have to burn
> cycles sorting the exception table.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>
> ---
>  scripts/.gitignore    |    1 +
>  scripts/Makefile      |    1 +
>  scripts/sortextable.c |  273 +++++++++++++++++++++++++++++++++++++++++++++++++
>  scripts/sortextable.h |  168 ++++++++++++++++++++++++++++++

If there is only a single file including the .h file - then there is no gain.
Just fold it into the .c file.


	Sam
