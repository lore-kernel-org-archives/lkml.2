Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934429Ab0EDWXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 18:23:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43719 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933047Ab0EDWXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 18:23:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [Bug #15729] BUG: physmap modprobe & rmmod
Date: Wed, 5 May 2010 00:24:15 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Hartley Sweeten <hsweeten@visionengravers.com>
References: <JzEGxUyyQHG.A.ZtH.YHJ4LB@chimera> <8VO9AsMlpMD.A.-m.4IJ4LB@chimera> <4BE09D4A.6040808@oracle.com>
In-Reply-To: <4BE09D4A.6040808@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005050024.15254.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 May 2010, Randy Dunlap wrote:
> On 05/04/10 14:21, Rafael J. Wysocki wrote:
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
> Yes, leave it as open until the patch is merged, please.

Sure (that's the default policy).

Rafael
