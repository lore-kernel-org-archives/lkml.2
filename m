Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab0GIU4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 16:56:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33761 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754964Ab0GIU4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 16:56:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [Bug #16256] tpm_tis breaks suspend/hibernate on kernels > 2.6.34
Date: Fri, 9 Jul 2010 22:55:01 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "David Safford" <safford@watson.ibm.com>,
       "James Morris" <jmorris@namei.org>,
       "Rajiv Andrade" <srajiv@linux.vnet.ibm.com>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera> <TXb9XdQzJoD.A.QYC.1MmNMB@chimera> <201007090823.47530.helmut.schaa@googlemail.com>
In-Reply-To: <201007090823.47530.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007092255.01688.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 09, 2010, Helmut Schaa wrote:
> Am Freitag 09 Juli 2010 schrieb Rafael J. Wysocki:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.34.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16256
> > Subject		: tpm_tis breaks suspend/hibernate on kernels > 2.6.34
> > Submitter	: Helmut Schaa <helmut.schaa@googlemail.com>
> > Date		: 2010-06-20 11:15 (19 days old)
> > First-Bad-Commit: http://git.kernel.org/linus/225a9be24d799aa16d543c31fb09f0c9ed1d9caa
> > Handled-By	: Helmut Schaa <helmut.schaa@googlemail.com>
> > Patch		: http://marc.info/?l=tpmdd-devel&m=127609160616162&w=2
> 
> Seems like the patch didn't make it into mainline yet. So I guess it should
> still be listed here.

Yes, thanks for the update.

Rafael
