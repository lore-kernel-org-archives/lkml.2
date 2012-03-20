Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097Ab2CTBya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 21:54:30 -0400
Received: from tundra.namei.org ([65.99.196.166]:51604 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755989Ab2CTBy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 21:54:28 -0400
Date: Tue, 20 Mar 2012 12:54:24 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@parisplace.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [GIT] MAINTAINERS: Add Serge as maintainer of capabilities
In-Reply-To: <CACLa4puKa8O8g2i05myV4bSEY5DmnjcZrmrAk==mX+iLdcV=ew@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1203201253200.26596@tundra.namei.org>
References: <alpine.LRH.2.02.1203161217060.32664@tundra.namei.org> <CACLa4puKa8O8g2i05myV4bSEY5DmnjcZrmrAk==mX+iLdcV=ew@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1665246916-1188948363-1332208465=:26596"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-1188948363-1332208465=:26596
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 16 Mar 2012, Eric Paris wrote:

> > +M:     Serge Hallyn <serge.hallyn@canonical.com>
> > +L:     linux-security-module@vger.kernel.org
> > +S:     Supported
> > +F:     include/linux/capability.h
> > +F:     security/capability.c
> > +F:     security/commoncap.c
> 
> You forgot kernel/capability.c

Thanks, I'll fix that after rebasing with linus.




- James
-- 
James Morris
<jmorris@namei.org>
--1665246916-1188948363-1332208465=:26596--
