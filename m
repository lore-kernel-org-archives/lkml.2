Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab0EaDHt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 23:07:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:55498 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586Ab0EaDHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 23:07:48 -0400
Date: Sun, 30 May 2010 20:10:24 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Documentation/timers/hpet_example.c compile bug
Message-ID: <20100530201024.061537a9@infradead.org>
In-Reply-To: <4C0325DE.6020604@oracle.com>
References: <20100528113514.GA3686@osiris.boeblingen.de.ibm.com>
	<4C015FE6.8040004@oracle.com>
	<4C03203B.3050501@oracle.com>
	<20100530194907.67399986@infradead.org>
	<4C0325DE.6020604@oracle.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 May 2010 19:58:38 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On 05/30/10 19:49, Arjan van de Ven wrote:
> > On Sun, 30 May 2010 19:34:35 -0700
> > Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >>
> >> Does it even make sense to build hpet_example on s390?
> >> I.e., does s390 have hpet?
> >> If not, then a simple Kconfig "depends on X86" or "depends
> >> on !S390" will fix this.
> > 
> > HPET is very PC specific.
> > 
> > but.. even on x86, it does not really make sense, and exposing this
> > as an interface to userspace is a historical mistake, the use of
> > which we really ought to discourage.
> 
> Do you mean exposing anything that is in /usr/include/linux/hpet.h
> via ioctls? especially struct hpet_info ?

exposing even the concept of HPET, so yeah, including that header.
not all systems have hpet.. and frankly, we have better interfaces for
the same functionality...



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
