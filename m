Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab1LWPK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 10:10:59 -0500
Received: from tn-76-7-162-101.sta.embarqhsd.net ([76.7.162.101]:59331 "EHLO
	animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848Ab1LWPK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 10:10:57 -0500
Date: Fri, 23 Dec 2011 10:10:53 -0500
From: Wakko Warner <wakko@animx.eu.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Gaurav Saxena <grvsaxena419@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Intercepting system calls
Message-ID: <20111223151053.GB25014@animx.eu.org>
Mail-Followup-To: Jiri Kosina <jkosina@suse.cz>,
	Gaurav Saxena <grvsaxena419@gmail.com>,
	linux-kernel@vger.kernel.org
References: <CAOh0hwO03GJ2ApNW6GV5fJKJ4S+hTv3An7vLTO4qaL4U9grdJg@mail.gmail.com>
 <CAFLxGvyWWCAfk-fCCc3NhCE=KbE-Y7ivO5gynSbCubxPC8d-uw@mail.gmail.com>
 <CAOh0hwOpzXRp9k70qK6rWURE5414c0=A2ALEBtL=77xxDW9hiw@mail.gmail.com>
 <20111222190359.GF604@animx.eu.org>
 <alpine.LRH.2.00.1112231044360.21599@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1112231044360.21599@twin.jikos.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Thu, 22 Dec 2011, Wakko Warner wrote:
> 
> > > Oh. I will not do it then, could you suggest me something so that I
> > > could prevent unlink on some file say using kernel support. I want to
> > > save file on unlink how could I do that without kernel support, or how
> > > could I do that using a kernel module.
> > 
> > I wrote a library that can be loaded in userspace that does this.  It's not
> > very polished, but it works for me.  I use it for rsync when I want files
> > "deleted" but not from the filesystem.  It creates a .deleted directory in
> > the $PWD.
> 
> I don't see a way how library could cover any arbitrary userspace process 
> issuing unlink() (consider statically linked binaries, for starters).

It cannot.  I already understand that static binaries cannot be trapped like
this.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
