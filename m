Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314Ab0GTPF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 11:05:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760904Ab0GTPF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 11:05:27 -0400
MIME-Version: 1.0
In-Reply-To: <20100720065925.GB16367@liondog.tnic>
References: <20100719181240.fc3066cd.randy.dunlap@oracle.com>
	<AANLkTilwV9PPdpM5JZ65M_TYr_XfVDBHCLXLJVYkTEav@mail.gmail.com>
	<20100719220545.098cb7aa.randy.dunlap@oracle.com>
	<20100720065925.GB16367@liondog.tnic>
Date: Tue, 20 Jul 2010 08:04:49 -0700
Message-ID: <AANLkTil_yFXag1H-8eh-AMLweDbqF47oqQZ02Dtfb4bP@mail.gmail.com>
Subject: Re: [git pull] documentation: fix almost duplicate filenames 
	(io/IO-mapping.txt)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>, Randy Dunlap <randy.dunlap@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Kees Bakker <kees.bakker@xs4all.nl>, Keith Packard <keithp@keithp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 11:59 PM, Borislav Petkov <bp@alien8.de> wrote:
>>
>> Will do... but how do I edit the commit message?
>
> git commit --amend
>
> after you've made sure that the commit you want to edit is at the tip of
> the current branch.

.. and if it's not at the top (like it is this time), do "man
git-rebase" and then you can use "git rebase -i origin" (where
"origin" is whatever your upstream is).

And yeah, this is not something you really should do to anything
you've published, but you'll know better next time and fix it all up
_before_ you publish it and ask me to pull ;)

              Linus
