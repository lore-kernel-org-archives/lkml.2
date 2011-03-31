Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733Ab1CaNxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 09:53:09 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:57537 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757624Ab1CaNxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 09:53:07 -0400
MIME-Version: 1.0
In-Reply-To: <20110331062949.GA29526@elte.hu>
References: <20110331032307.GA27999@vigoh> <20110331062949.GA29526@elte.hu>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Thu, 31 Mar 2011 10:52:46 -0300
Message-ID: <AANLkTinRvCcY5kC+jeHgWp2RH7nzgexXKcRGb1SwhsE_@mail.gmail.com>
Subject: Re: [GIT PULL] Fix common misspellings
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        lucas.de.marchi@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Thu, Mar 31, 2011 at 3:29 AM, Ingo Molnar <mingo@elte.hu> wrote:
> I've gone over your changes and noticed one very small thing, you've changed
> copyright strings as well:
>
> - * Copyright (C) 2007 Marvell Internation Ltd.
> + * Copyright (C) 2007 Marvell International Ltd.
> - * Copyright (C) 2007 Marvell Internation Ltd.
> + * Copyright (C) 2007 Marvell International Ltd.
> - * Copyright (C) 2007 Marvell Internation Ltd.
> + * Copyright (C) 2007 Marvell International Ltd.
> - * Copyright (C) 2007-2008 Marvell Internation Ltd.
> + * Copyright (C) 2007-2008 Marvell International Ltd.
> - * Copyright (C) 2007 Marvell Internation Ltd.
> + * Copyright (C) 2007 Marvell International Ltd.
> - * Copyright (C) 2007 Marvell Internation Ltd.
> + * Copyright (C) 2007 Marvell International Ltd.
> - * Copyright (C) 2007 Marvell Internation Ltd.
> + * Copyright (C) 2007 Marvell International Ltd.
> - * Copyright (c) 2002 The Regents of the Unviersity of Michigan
> + * Copyright (c) 2002 The Regents of the University of Michigan
>
> While all the fixes are correct, i'd advise against changing copyright notices
> without the SOB of the authors. The s/Unviersity/University fix would be ok i
> guess because it's a very clear typo, but the Marvell one is borderline (while
> it too is probably a typo) i think it needs a signoff from those who put the
> copyright notices there in that form.
>
> You could leave out those bits from the patch as well.

Ok. I saw these when manually reviewing and a 'git grep "Marvell
International Ltd"'  revealed a lot of places using "the right form",
so I assumed they were in fact typos.

I'll remove them for now, and send a separate patch later asking for
the required s-o-b.


thanks
Lucas De Marchi
