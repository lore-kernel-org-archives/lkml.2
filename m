Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab1AFQad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 11:30:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751538Ab1AFQac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 11:30:32 -0500
MIME-Version: 1.0
In-Reply-To: <20110106104816.GA4026@tiehlicka.suse.cz>
References: <AANLkTikKA-nStyNjkdsVa8hd=PFQR3tYTJh3MnfpNkD8@mail.gmail.com> <20110106104816.GA4026@tiehlicka.suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 6 Jan 2011 08:29:22 -0800
Message-ID: <AANLkTi=aTKFVO8Lx=fDUGrxVaQL73XrsxoOP7-qYKksb@mail.gmail.com>
Subject: Re: Linux 2.6.37
To: Michal Hocko <mhocko@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 2:48 AM, Michal Hocko <mhocko@suse.cz> wrote:
>
> It seems that there is still a regression for intel graphic cards
> backlight. One report is https://bugzilla.kernel.org/show_bug.cgi?id=22672.
> I can reproduce the problem easily by:
> xset dpms force standby; sleep 3s; xset dpms force on
>
> backlight doesn't get up (there is really dark picture though which
> doesn't get brighter by function keys which work normally) after dpms on
> until I close and open lid.

Hmm. That commit no longer reverts cleanly, so it's not trivial to
test whether all those things are exactly the same issue. It's been
bisected in the bugzilla entry, but it would be good to verify that
yes, reverting it really does fix the issue, and your issue is the
exact same one.

Chris, any ideas?

                       Linus
