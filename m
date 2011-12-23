Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab1LWJpd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 04:45:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756460Ab1LWJpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 04:45:30 -0500
Date: Fri, 23 Dec 2011 10:45:16 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Wakko Warner <wakko@animx.eu.org>
Cc: Gaurav Saxena <grvsaxena419@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Intercepting system calls
In-Reply-To: <20111222190359.GF604@animx.eu.org>
Message-ID: <alpine.LRH.2.00.1112231044360.21599@twin.jikos.cz>
References: <CAOh0hwO03GJ2ApNW6GV5fJKJ4S+hTv3An7vLTO4qaL4U9grdJg@mail.gmail.com> <CAFLxGvyWWCAfk-fCCc3NhCE=KbE-Y7ivO5gynSbCubxPC8d-uw@mail.gmail.com> <CAOh0hwOpzXRp9k70qK6rWURE5414c0=A2ALEBtL=77xxDW9hiw@mail.gmail.com> <20111222190359.GF604@animx.eu.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Dec 2011, Wakko Warner wrote:

> > Oh. I will not do it then, could you suggest me something so that I
> > could prevent unlink on some file say using kernel support. I want to
> > save file on unlink how could I do that without kernel support, or how
> > could I do that using a kernel module.
> 
> I wrote a library that can be loaded in userspace that does this.  It's not
> very polished, but it works for me.  I use it for rsync when I want files
> "deleted" but not from the filesystem.  It creates a .deleted directory in
> the $PWD.

I don't see a way how library could cover any arbitrary userspace process 
issuing unlink() (consider statically linked binaries, for starters).

-- 
Jiri Kosina
SUSE Labs

