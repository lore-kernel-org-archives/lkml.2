Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab1AJV4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 16:56:51 -0500
Received: from tundra.namei.org ([65.99.196.166]:39619 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634Ab1AJV4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 16:56:49 -0500
Date: Tue, 11 Jan 2011 08:56:46 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Security subsystem changes for 2.6.38
In-Reply-To: <AANLkTinU2mNyTEc55=ypDPXWah_ozaV1BHWBqCenxp1Z@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1101110855330.28785@tundra.namei.org>
References: <alpine.LRH.2.00.1101101136001.21289@tundra.namei.org> <AANLkTinU2mNyTEc55=ypDPXWah_ozaV1BHWBqCenxp1Z@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jan 2011, Linus Torvalds wrote:

> On Sun, Jan 9, 2011 at 4:46 PM, James Morris <jmorris@namei.org> wrote:
> >
> > Also, following discussion at the kernel summit, several sub-maintainers
> > have now established public git trees from which I pull.
> 
> Pulled. However, looking at it, there's a couple of things that
> strikes me as having room for improvement. Eg a missing sign-off in
> commit 676dac4b1bee, and several "merge branch 'master'" where the
> merge message leaves people with absolutely zero idea what the merge
> was (which master? What?) or why.

In these cases it's my local 'master', which is tracking your tree.  I'll 
look at renaming that or creating a new branch called linus-master.


-- 
James Morris
<jmorris@namei.org>
