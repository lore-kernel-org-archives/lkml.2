Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab0DRNbY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 09:31:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54091 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab0DRNbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 09:31:22 -0400
From: Karsten Keil <isdn@linux-pingi.de>
Reply-To: isdn@linux-pingi.de
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] gigaset: include cleanup cleanup
Date: Sun, 18 Apr 2010 15:31:14 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.27.45-0.1-default; KDE/4.4.1; x86_64; ; )
Cc: Tilman Schmidt <tilman@imap.cc>, David Miller <davem@davemloft.net>,
       Hansjoerg Lipp <hjlipp@web.de>, i4ldeveloper@listserv.isdn4linux.de,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100416220858.A19F540123@xenon.ts.pxnet.com> <4BCA6B8E.9000408@kernel.org>
In-Reply-To: <4BCA6B8E.9000408@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004181531.14871.isdn@linux-pingi.de>
X-Provags-ID: V01U2FsdGVkX19zGwe+DBafIjW3JhgJyGkBBSUdg/yRt5+VWgS
 68+9FVyPhoJenZpmy9gWT6lF8MgAi7CIElbURf5lZyA+aNVdfm
 mzRxoRZJS2z0jSzylPaetLONs7wrEHc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sonntag, 18. April 2010 04:16:46 Tejun Heo wrote:
> Hello,
> 
> On 04/17/2010 07:08 AM, Tilman Schmidt wrote:
> > Commit 5a0e3ad causes slab.h to be included twice in many of the
> > Gigaset driver's source files, first via the common include file
> > gigaset.h and then a second time directly. Drop the spares, and
> > use the opportunity to clean up a few more similar cases.
> >
> > Impact: cleanup, no functional change
> > Signed-off-by: Tilman Schmidt <tilman@imap.cc>
> > CC: Tejun Heo <tj@kernel.org>
> 
> Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Karsten Keil <isdn@linux-pingi.de>

> 
> Thanks for the clean up.
> 
> > Seeing that the "include cleanup" patch triggering this was accepted
> > after the merge window, I have hopes this one will be accepted, too.
> 
> Hmm... through which tree should this go through?  I can route it
> through percpu but maybe taking the usual isdn patch path would be
> better?
> 
I think David Miller will take it.

Karsten
