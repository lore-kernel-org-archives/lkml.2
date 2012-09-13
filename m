Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab2IMJcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 05:32:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34802 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706Ab2IMJcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 05:32:46 -0400
Date: Thu, 13 Sep 2012 11:32:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: Konstantin Ryabitsev <mricon@kernel.org>
Cc: Leonard Tse <xiehao5@gmail.com>, ftpadmin@kernel.org,
        linux-kernel@vger.kernel.org, greg@kroah.com, leoli@freescale.com,
        triplex@zh-kernel.org, tshibata@ab.jp.nec.com, k-keiichi@bx.jp.nec.com,
        minchan.kim@gmail.com
Subject: Re: [PATCH]URL is unavailable
Message-ID: <20120913093241.GA15810@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Konstantin Ryabitsev <mricon@kernel.org>,
	Leonard Tse <xiehao5@gmail.com>, ftpadmin@kernel.org,
	linux-kernel@vger.kernel.org, greg@kroah.com, leoli@freescale.com,
	triplex@zh-kernel.org, tshibata@ab.jp.nec.com,
	k-keiichi@bx.jp.nec.com, minchan.kim@gmail.com
References: <CAHVxiJCv+tzx4rtL2Mu0zAYEurrSwHANwvL_bpDUR7ZMXJdAyg@mail.gmail.com>
 <20120912160306.GA16482@x1.osrc.amd.com>
 <5051334E.4010802@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5051334E.4010802@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 09:13:50PM -0400, Konstantin Ryabitsev wrote:
> On 12/09/12 12:03 PM, Borislav Petkov wrote:
> > Dear KORG admins, what are the chances of userweb.kernel.org coming back
> > online?
> 
> Hello:
> 
> There is no ETA on that service being available. It may not ever come
> back, at least not in the way it was before.
> 
> That being said, I'm perfectly willing to set up a few redirects in
> place if broken URLs are causing problems. I just cannot use any of the
> existing backups of userweb data, as it is under a strict "do not use,
> ever" quarantine.
> 
> If someone can provide me with trusted backups of that data, I will
> provide hosting and redirects to unbreak the URLs.

My memory is hazy on this, but after the move, what's the policy on
enabling users.kernel.org or userweb.kernel org or some other user web
serving thing? I vaguely remember that we don't want to do this anymore
but I'm not sure.

In any case, if we do, it would probably be better to have a whole
different machine for such stuff and let users upload their stuff again
without touching the old backups at all...

Hmm.

-- 
Regards/Gruss,
    Boris.
