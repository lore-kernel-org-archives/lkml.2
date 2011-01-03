Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab1ACNsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:48:11 -0500
Received: from cantor.suse.de ([195.135.220.2]:45550 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503Ab1ACNsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:48:09 -0500
Date: Mon, 3 Jan 2011 14:48:07 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Piotr Hosowicz <piotr@hosowicz.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: GIT question - am I doing it correctly?
Message-ID: <20110103134807.GA3911@tiehlicka.suse.cz>
References: <4D1B6066.9000701@example.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D1B6066.9000701@example.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 29-12-10 17:23:02, Piotr Hosowicz wrote:
> Hello,

Hi,

> 
> Everytime I git pull tyhe Linus' sources but before I build I apply
> Peter Zijlstra's fixes, Takashi Iwai's sources and Dave Miller's
> sources. The sequence is:
> 
> # the Linus' sources
> git pull
> 
> # external sources
> git remote add some_name git://some_URL.git
> 
> # update
> git remote update
> 
> Then configure and I build. I noticed that especially Peter's
> git-update very quickly, not as long as they did before.
> 
> Is my procedure correct? I am new to GIT.

What do you want to achieve? You want to build the tree that you have
added as a remote? If yes then you need to checkout a branch from that
remote

git checkout -b your_branch_name some_name/branch_you_want

then you will have a new your_branch_name which points to the tip of the
remote's branch and you can configure and make the tree.

Please note that 'git remote add && git remote update' will just add
commits from that remote tree and it doesn't affect your local copy
anyhow.

If you are new to GIT I would strongly encourage you to read through the
following ebook: http://progit.org/book/

> 
> Regards,
> 
> Piotr Hosowicz
> 
> -- 
> W trosce o najm?odsze pokolenie, nasi ustawodawcy winni znowelizowa?
> ustaw? o wychowaniu w trze?wo?ci i przeciwdzia?aniu alkoholizmowi tak,
> ?eby zakaza? wprowadzania na rynek gier planszowych, kt?rych celem
> jest jak najszybsze dotarcie do mety.
> NP: Peter Green Splinter Group - Turn Your Love Away
> NB: 2.6.37-rc8
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
