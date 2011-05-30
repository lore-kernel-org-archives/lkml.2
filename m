Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab1E3Uh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 16:37:29 -0400
Received: from unix.wroclaw.pl ([94.23.28.62]:47476 "EHLO unix.wroclaw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986Ab1E3Uh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 16:37:28 -0400
X-Greylist: delayed 2034 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 May 2011 16:37:28 EDT
Date: Mon, 30 May 2011 22:03:29 +0200
From: Mariusz Kozlowski <mk@lab.zgora.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.0-rc1
Message-ID: <20110530200329.GA1833@mako-laptop>
References: <BANLkTinE8eSSovGx6CPPkTeCpqv8AsS2nw@mail.gmail.com>
 <BANLkTinsO2=tO_UyzzgeU6LE1fObgq+p1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinsO2=tO_UyzzgeU6LE1fObgq+p1Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Report: SpamAssassin 3.2.5 (2008-06-10) on unix.wroclaw.pl
	Spam=No score=-1.4 bayes=0.5 autolearn=disabled
	Spam Tests:
	* -1.4 ALL_TRUSTED Passed through trusted hosts only via SMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 06:47:57PM -0700, Linus Torvalds wrote:

[...]

> However, I did *not* rename the git tree, because that would just be a
> huge inconvenience to git users, so it's still in the same old place
> and yes, that means that my git tree is still called "linux-2.6.git"
> on kernel.org. But it has the v3.0-rc1 tag in it.
> 
> I'll probably add a symlink or something, if people really hate being
> reminded about our long history with the "2.6" numbering. But that
> won't be until closer to the real release, methinks.

You could consider freezing linux-2.6.git repository and creating new
linux-3.git repository that would serve for a couple of years until
linux-4.git. At the same time development history could be dropped between
trees so that inital clones are lighter. Anyone interested in history
can download idx/pack from linux-2.6.git repo and attach it using gratf
point[1] anyway.

Pros:
- obvious naming scheme wrt repository contents
- smaller initial clone
- new clean tag namespace

Cons:
- broken bisection for some time
- impaired log/blame/whatchanged and friends

Cons can be fixed by attaching history when needed.

[1] https://git.wiki.kernel.org/index.php/GraftPoint

-- 
Mariusz Kozlowski
