Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab1AJT0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 14:26:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753961Ab1AJT0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 14:26:16 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1101101136001.21289@tundra.namei.org>
References: <alpine.LRH.2.00.1101101136001.21289@tundra.namei.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 10 Jan 2011 11:25:54 -0800
Message-ID: <AANLkTinU2mNyTEc55=ypDPXWah_ozaV1BHWBqCenxp1Z@mail.gmail.com>
Subject: Re: [GIT] Security subsystem changes for 2.6.38
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 9, 2011 at 4:46 PM, James Morris <jmorris@namei.org> wrote:
>
> Also, following discussion at the kernel summit, several sub-maintainers
> have now established public git trees from which I pull.

Pulled. However, looking at it, there's a couple of things that
strikes me as having room for improvement. Eg a missing sign-off in
commit 676dac4b1bee, and several "merge branch 'master'" where the
merge message leaves people with absolutely zero idea what the merge
was (which master? What?) or why.

The ability to create merges without any commentary is admittedly a
git misfeature - it's _way_ too easy to create a merge which doesn't
actually tell what's going on. So I apologize for that, but I would
ask people to keep it in mind when doing "git pull" or "git merge" -
think about what the merge message actually tells others about what is
going on.

                             Linus
