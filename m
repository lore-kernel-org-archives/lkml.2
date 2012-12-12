Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab2LLWYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 17:24:03 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:47763 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755378Ab2LLWYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 17:24:00 -0500
Message-ID: <1355351039.27571.2.camel@joe-AO722>
Subject: Re: [TRIVIAL PATCH 16/26] x86: Convert print_symbol to %pSR
From: Joe Perches <joe@perches.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Jiri Kosina <trivial@kernel.org>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        "user-mode-linux-user@lists.sourceforge.net" 
	<user-mode-linux-user@lists.sourceforge.net>
Date: Wed, 12 Dec 2012 14:23:59 -0800
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F1C969495@ORSMSX108.amr.corp.intel.com>
References: <cover.1355335227.git.joe@perches.com>
	 <054f8a88fe46ae0b4c2669d0e155d84c11b66115.1355335228.git.joe@perches.com>
	 <20121212210959.GH8760@liondog.tnic> <1355347803.8538.16.camel@joe-AO722>
	 <3908561D78D1C84285E8C5FCA982C28F1C969495@ORSMSX108.amr.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-12 at 21:49 +0000, Luck, Tony wrote:
> > I think I'd go ahead and ACK this unless Tony has some comments. I'm not
> > happy about the two pr_emerg calls based on the conditional.
> 
> As written the patch has the nice property of not making any changes to the
> console output (except to eliminate the possibility of interleaved output that
> the original code had).

Well, it does eliminate a trailing space when m->cs != KERNEL_CS.
That probably won't hurt anything, but...


