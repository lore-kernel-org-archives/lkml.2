Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab1DGTWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 15:22:00 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46861 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab1DGTV7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 15:21:59 -0400
MIME-Version: 1.0
In-Reply-To: <20110407185043.GA11496@elte.hu>
References: <20110331032307.GA27999@vigoh> <20110331062949.GA29526@elte.hu>
 <20110331144400.GA2618@vigoh> <BANLkTin76790Y=6Q8vmq92b_4+7f+hzWZQ@mail.gmail.com>
 <BANLkTikDc0o6Kf5Ym5XkmpeY54fPc67SVw@mail.gmail.com> <20110407185043.GA11496@elte.hu>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Thu, 7 Apr 2011 16:21:39 -0300
Message-ID: <BANLkTinWkAR4tm-oi4535HemXAZnbYqJkg@mail.gmail.com>
Subject: Re: [GIT PULL] Fix common misspellings
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        lucas.de.marchi@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 7, 2011 at 3:50 PM, Ingo Molnar <mingo@elte.hu> wrote:
> Some other mistakes:
>
> +       .usecount = 1,              /* REVISIT: why can't' this be disabled? */
> +       .usecount = 1,              /* REVISIT: why can't' this be disabled? */
> +        * isn't' set.
> +        * isn't' set.
> +        * isn't' set.
> +       /* We can't' use dev_ready here, but at least we wait for the
> +               dev_dbg(&p_dev->dev, "Configuration isn't't locked\n");
> +       /* Drop not U2M frames, can't's drop here because we will drop beacon in this case */
> +       /* Drop not U2M frames, can't's drop here because we will drop beacon in this case */

Do I squash these in the same commit or it's better to commit them on
top of the initial fix?



Lucas De Marchi
