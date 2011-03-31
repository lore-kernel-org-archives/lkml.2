Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab1CaGaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 02:30:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49651 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302Ab1CaGaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 02:30:04 -0400
Date: Thu, 31 Mar 2011 08:29:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        lucas.de.marchi@gmail.com
Subject: Re: [GIT PULL] Fix common misspellings
Message-ID: <20110331062949.GA29526@elte.hu>
References: <20110331032307.GA27999@vigoh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331032307.GA27999@vigoh>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi Lucas,

* Lucas De Marchi <lucas.demarchi@profusion.mobi> wrote:

> 
> Hi Linus,
> 
> Please pull the following fix for common misspellings in kernel code:
> 
> git://git.profusion.mobi/users/lucas/linux-2.6.git for-linus
> 
> I was doing it in a per maintainer basis, but as noted by Ingo, this was not
> working out.
> 
> There's only one big patch that fixes misspellings in
>  * Documentation
>  * Comments
>  * Strings that are used only in printk and the like

I've gone over your changes and noticed one very small thing, you've changed 
copyright strings as well:

- * Copyright (C) 2007 Marvell Internation Ltd.
+ * Copyright (C) 2007 Marvell International Ltd.
- * Copyright (C) 2007 Marvell Internation Ltd.
+ * Copyright (C) 2007 Marvell International Ltd.
- * Copyright (C) 2007 Marvell Internation Ltd.
+ * Copyright (C) 2007 Marvell International Ltd.
- * Copyright (C) 2007-2008 Marvell Internation Ltd.
+ * Copyright (C) 2007-2008 Marvell International Ltd.
- * Copyright (C) 2007 Marvell Internation Ltd.
+ * Copyright (C) 2007 Marvell International Ltd.
- * Copyright (C) 2007 Marvell Internation Ltd.
+ * Copyright (C) 2007 Marvell International Ltd.
- * Copyright (C) 2007 Marvell Internation Ltd.
+ * Copyright (C) 2007 Marvell International Ltd.
- * Copyright (c) 2002 The Regents of the Unviersity of Michigan
+ * Copyright (c) 2002 The Regents of the University of Michigan

While all the fixes are correct, i'd advise against changing copyright notices 
without the SOB of the authors. The s/Unviersity/University fix would be ok i 
guess because it's a very clear typo, but the Marvell one is borderline (while 
it too is probably a typo) i think it needs a signoff from those who put the 
copyright notices there in that form.

You could leave out those bits from the patch as well.

Thanks,

	Ingo
