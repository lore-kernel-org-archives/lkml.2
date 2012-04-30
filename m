Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab2D3BnL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 21:43:11 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:37745 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab2D3BnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 21:43:09 -0400
Message-ID: <1335750187.27452.23.camel@shrek.rexursive.com>
Subject: Re: [PATCH v11]: Hibernation: fix the number of pages used for
 hibernate/thaw buffering
From: Bojan Smojver <bojan@rexursive.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Per Olofsson <pelle@debian.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Date: Mon, 30 Apr 2012 11:43:07 +1000
In-Reply-To: <201204292308.43593.rjw@sisk.pl>
References: <1334267969.2573.14.camel@shrek.rexursive.com>
	 <1335485772.2136.21.camel@shrek.rexursive.com>
	 <1335486369.2136.24.camel@shrek.rexursive.com>
	 <201204292308.43593.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-29 at 23:08 +0200, Rafael J. Wysocki wrote:
> > These patches should go to linux-pm/linux-next (in that order):
> > 
> > http://marc.info/?l=linux-kernel&m=133522096505280&w=2
> > http://marc.info/?l=linux-kernel&m=133548592706940&w=2
> 
> Both are in my linux-next branch.
> 
> > Only this patch should to to -stable:
> > 
> > http://marc.info/?l=linux-kernel&m=133522096505280&w=2
> 
> And this one is in my fixes branch in addition and will be pushed to
> Linus shortly. 

Excellent.

-- 
Bojan

