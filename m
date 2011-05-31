Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab1EaFkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 01:40:17 -0400
Received: from unix.wroclaw.pl ([94.23.28.62]:43398 "EHLO unix.wroclaw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab1EaFkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 01:40:16 -0400
Date: Tue, 31 May 2011 07:40:08 +0200
From: Mariusz Kozlowski <mk@lab.zgora.pl>
To: david@lang.hm
Cc: Mariusz Kozlowski <mk@lab.zgora.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.0-rc1
Message-ID: <20110531054008.GA1906@mako-laptop>
References: <BANLkTinE8eSSovGx6CPPkTeCpqv8AsS2nw@mail.gmail.com>
 <BANLkTinsO2=tO_UyzzgeU6LE1fObgq+p1Q@mail.gmail.com>
 <20110530200329.GA1833@mako-laptop>
 <alpine.DEB.2.02.1105301545420.5766@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1105301545420.5766@asgard.lang.hm>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Report: SpamAssassin 3.2.5 (2008-06-10) on unix.wroclaw.pl
	Spam=No score=-1.4 bayes=0.5 autolearn=disabled
	Spam Tests:
	* -1.4 ALL_TRUSTED Passed through trusted hosts only via SMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 03:48:49PM -0700, david@lang.hm wrote:
> >You could consider freezing linux-2.6.git repository and creating new
> >linux-3.git repository that would serve for a couple of years until
> >linux-4.git. At the same time development history could be dropped between
> >trees so that inital clones are lighter. Anyone interested in history
> >can download idx/pack from linux-2.6.git repo and attach it using gratf
> >point[1] anyway.
> >
> >Pros:
> >- obvious naming scheme wrt repository contents
> >- smaller initial clone
> >- new clean tag namespace
> >
> >Cons:
> >- broken bisection for some time
> >- impaired log/blame/whatchanged and friends
> 
> in addition won't there be problems merging in work done on the old
> tree? (since there would be no common history)

Everyone would need to restart and probably reapply they changes on top
of new tree (because of lack of common history).

> everyone would need to re-clone their repository (and attaching
> history wouldn't help this)
> 
> there are probably others.
> 
> frankly I don't see any real benifits from the Pros you list. the
> initial clone is already rather small, it probably won't make that
> big a difference to throw away several years of history.

linux-2.6.git is all about lots of small changes so size isn't all that
big today but there are quite many objects. Using grafts might help
decreasing size of repository. I just mentioned it because it is a bit
of a revolution time anyway and otherwise current tree will grow for next
decade or so.

It's just an idea, I'm happy either way.

Thanks.
-- 
Mariusz Kozlowski
