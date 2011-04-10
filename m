Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab1DJPKA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 11:10:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60627 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133Ab1DJPJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 11:09:58 -0400
Date: Sun, 10 Apr 2011 08:09:56 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "Justin P. Mattock" <justinmattock@gmail.com>, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: Re: [PATCH]arch:Kconfig.locks Remove unused config option.
In-Reply-To: <20110330062258.GA2600@osiris.boeblingen.de.ibm.com>
Message-ID: <alpine.LNX.2.00.1104081955540.6392@deuxcents.site>
References: <1301416611-3651-1-git-send-email-justinmattock@gmail.com> <20110329175302.GF8529@home.goodmis.org> <20110330062258.GA2600@osiris.boeblingen.de.ibm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011, Heiko Carstens wrote:

> > > using a cleanup script I found this, could be real/fake not sure
> > > I grepped the whole kernel and only found this. If/when you have
> > > time let me know..
> > 
> > This was added by: 36cd3c9f925b9307236505ae7ad1ad7ac4d4357c
> > mutex: have non-spinning mutexes on s390 by default
> > 
> > and removed by: fa188ae1657d6edc7963d524ce9a0650fe725242
> > [S390] mutex: enable spinning mutex on s390
> > 
> > So I think you are safe in removing it.
> 
> Yes, that's just a leftover.
> 
> > > Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> > 
> > Acked-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Applied, thanks everybody.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

