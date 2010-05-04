Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760318Ab0EDWWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 18:22:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:59863 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757124Ab0EDWWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 18:22:43 -0400
Subject: RE: [Bug #15729] BUG: physmap modprobe & rmmod
From: David Woodhouse <dwmw2@infradead.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <0D753D10438DA54287A00B0270842697636EB83FB2@AUSP01VMBX24.collaborationhost.net>
References: <JzEGxUyyQHG.A.ZtH.YHJ4LB@chimera>
	 <8VO9AsMlpMD.A.-m.4IJ4LB@chimera>
	 <0D753D10438DA54287A00B0270842697636EB83FB2@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 May 2010 23:22:31 +0100
Message-ID: <1273011751.31892.5700.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-04 at 17:15 -0500, H Hartley Sweeten wrote:
> On Tuesday, May 04, 2010 2:21 PM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.33.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15729
> > Subject		: BUG: physmap modprobe & rmmod
> > Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
> > Date		: 2010-04-02 20:40 (33 days old)
> > Message-ID	: <20100402134058.c4682716.randy.dunlap@oracle.com>
> > References	: http://marc.info/?l=linux-kernel&m=127024096210230&w=2
> > Handled-By	: Hartley Sweeten <hsweeten@visionengravers.com>
> > Patch		: https://patchwork.kernel.org/patch/90497/
> 
> This patch is not yet in Linus' tree, it is in linux-next.  David?

Is it a regression? People have been configuring their kernel stupidly
and then acting surprised when it didn't work for _ages_... what's new?

-- 
dwmw2

