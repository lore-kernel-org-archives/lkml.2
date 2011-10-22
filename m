Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab1JVUoa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 16:44:30 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:56632 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab1JVUo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 16:44:29 -0400
X-Greylist: delayed 3612 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Oct 2011 16:44:29 EDT
Date: Sat, 22 Oct 2011 15:40:09 -0400 (EDT)
From: Peter Foley <pefoley2@verizon.net>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Peter Foley <pefoley2@verizon.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>,
        mmarek@suse.cz
Subject: Re: [PATCH] kbuild: fix set but not used warnings
In-reply-to: <CACqU3MXS6-uE01EVAW1KdCViKioSz_F79YqzYwdTLrmc8hoMAw@mail.gmail.com>
Message-id: <alpine.LNX.2.00.1110221538570.59156@linux>
References: <alpine.LNX.2.00.1110221400040.59156@linux>
 <CACqU3MXS6-uE01EVAW1KdCViKioSz_F79YqzYwdTLrmc8hoMAw@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-version: 1.0
Content-type: MULTIPART/MIXED; BOUNDARY="0-802318585-1319312410=:59156"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-802318585-1319312410=:59156
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Sat, 22 Oct 2011, Arnaud Lacombe wrote:

> Hi,
> 
> On Sat, Oct 22, 2011 at 2:01 PM, Peter Foley <pefoley2@verizon.net> wrote:
> > Remove set but not used variables to fix warnings.
> >
> >  HOSTCC  scripts/kconfig/gconf.o
> > /usr/src/lto/scripts/kconfig/gconf.c: In function 'change_sym_value':
> > /usr/src/lto/scripts/kconfig/gconf.c:833:11: warning: variable 'oldval' set but not used [-Wunused-but-set-variable]
> > /usr/src/lto/scripts/kconfig/gconf.c: In function 'update_tree':
> > /usr/src/lto/scripts/kconfig/gconf.c:1281:19: warning: variable 'prop' set but not used [-Wunused-but-set-variable]
> >
> > Signed-off-by: Peter Foley <pefoley2@verizon.net>
> >
> s/kbuild/kconfig/ in the subject, that help to know changes is only
> limited to scripts/kconfig/
> 
>  - Arnaud

Noted. Should I resend this patch? 

Peter
--0-802318585-1319312410=:59156--
