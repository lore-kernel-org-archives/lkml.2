Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab1GINo2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 09:44:28 -0400
Received: from mail.sdinet.de ([78.47.32.153]:47667 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675Ab1GINo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 09:44:27 -0400
Date: Sat, 9 Jul 2011 15:42:44 +0200 (CEST)
From: Sven-Haegar Koch <haegar@sdinet.de>
X-X-Sender: haegar@aurora
To: Suresh Jayaraman <sjayaraman@suse.de>
cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        Linux-Kernel-Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: 3.0-rc+git OOPS losetup on cifs
In-Reply-To: <alpine.DEB.2.02.1107090250240.5791@aurora>
Message-ID: <alpine.DEB.2.02.1107091541080.17541@aurora>
References: <alpine.DEB.2.02.1107042132500.18300@aurora> <4E155F6F.6070506@suse.de> <alpine.DEB.2.02.1107090250240.5791@aurora>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jul 2011, Sven-Haegar Koch wrote:

> On Thu, 7 Jul 2011, Suresh Jayaraman wrote:
> 
> > On 07/05/2011 01:18 AM, Sven-Haegar Koch wrote:
> > > Since a short while (I know it worked with 3.0-rc1) loopback-mounting an 
> > > image on a samba server mounted with cifs oopses the kernel.
> ...
> > I couldn't reproduce this with 3.0-rc6 with a smaller image file (1GB).
> > But I see no relevant fixes between -rc5 and -rc6.
> > 
> > Can you try to reproduce the same problem with a smaller non-encrypted file?
> 
> I can, and it seems something even more fundamental.


Update for the list (archive) readers:

The patch in https://bugzilla.kernel.org/show_bug.cgi?id=38972#c12 fixes 
the problem for me completely.

Thanks Jeff Layton

c'ya
sven-haegar

-- 
Three may keep a secret, if two of them are dead.
- Ben F.
