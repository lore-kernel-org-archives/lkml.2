Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab2DPUfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:35:37 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53849 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754938Ab2DPUfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:35:36 -0400
Message-ID: <1334608487.3428.5.camel@joe2Laptop>
Subject: Re: Please fix or revert: [PATCH] checkpatch: add --strict tests
 for braces, comments and casts
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        apw@canonical.com
Date: Mon, 16 Apr 2012 14:34:47 -0600
In-Reply-To: <20120416202654.GA4678@gmail.com>
References: <20120416091719.GA4113@gmail.com>
	 <20120416.142728.864894452301706752.davem@davemloft.net>
	 <20120416202654.GA4678@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-16 at 22:26 +0200, Ingo Molnar wrote:
>  1) It's butt ugly and it violates every basic principle of
>     typography. Saving a line is often counter-productive, a 
>     well placed whitespace (vertical or horizontal) will often 
>     increase readability. Key is good balance.

True enough.

>     If you don't "see" it as ugly it's simply because your brain
>     is not wired up to see 3D/2D geometry as a significant
>     source of information. A significant portion (I'd 
>     guesstimate a narrow majority) of kernel hackers *does* see
>     2D/3D layout details in code and finds inconsistencies in 
>     them counterproductive.

I believe there's an empty hat somewhere that must
have produced this email.

I rather doubt anyone "sees" 3d geometries out of
a coding style.  Otherwise, cite please...

