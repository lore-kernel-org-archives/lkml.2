Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab1HCUDD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 16:03:03 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:51599 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754118Ab1HCUC4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 16:02:56 -0400
Date: Wed, 3 Aug 2011 13:02:53 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Tony Luck <tony.luck@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [GIT PATCH] APEI patches for Linux 3.1
Message-Id: <20110803130253.db8dd045.rdunlap@xenotime.net>
In-Reply-To: <CA+8MBbKavpgkf-ByB5-x9k5NCnW_W9Nkp2pQMXTGvTZEdTYg1w@mail.gmail.com>
References: <alpine.LFD.2.02.1108031137590.22067@x980>
	<CA+55aFxST2J+LDMB=1ctnw2WGxV+a-cm3FE-1AjwnXMNDkt32g@mail.gmail.com>
	<CA+8MBbKavpgkf-ByB5-x9k5NCnW_W9Nkp2pQMXTGvTZEdTYg1w@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Aug 2011 12:10:14 -0700 Tony Luck wrote:

> On Wed, Aug 3, 2011 at 9:26 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >  fatal: Couldn't find remote ref apei-release
> >
> > Forgot yo push?
> 
> Looks like he pushed to the wrong tree. There is a 3 hour old
> apei-release branch here:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-idle-2.6.git
> apei-release

Len did send a follow-up (correction) email that said:

typo fixed -- the real tree is here

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git apei-release


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
