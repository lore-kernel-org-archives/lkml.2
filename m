Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab0G0SpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 14:45:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36062 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435Ab0G0SpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 14:45:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [Bug #16271] 2.6.35-rc3 regression: IBM Maia system is unbootable [ACPI related?]
Date: Tue, 27 Jul 2010 20:44:00 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Len Brown <len.brown@intel.com>
References: <Lupw7pePXBO.A.fZH.G2XSMB@chimera> <tneGvaw1wLL.A.1sB.C4XSMB@chimera> <1280188821.7125.486.camel@mulgrave.site>
In-Reply-To: <1280188821.7125.486.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007272044.00237.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 27, 2010, James Bottomley wrote:
> On Fri, 2010-07-23 at 13:47 +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.34.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16271
> > Subject		: 2.6.35-rc3 regression: IBM Maia system is unbootable [ACPI related?]
> > Submitter	: James Bottomley <James.Bottomley@hansenpartnership.com>
> > Date		: 2010-06-21 16:03 (33 days old)
> > Message-ID	: <1277136189.10998.63.camel@mulgrave.site>
> > References	: http://marc.info/?l=linux-kernel&m=127713622821166&w=2
> > Handled-By	: Len Brown <len.brown@intel.com>
> > Patch		: https://patchwork.kernel.org/patch/108497/
> 
> Just got back to the machine in question.  It's gone in 2.6.35-rc6+ (can
> we get rid of this stupid '+'?) by
> 
> commit 3d695839a135a9b3f24b0d7cfd9c4fde2eadd2c5
> Author: Len Brown <len.brown@intel.com>
> Date:   Mon Jun 28 20:55:01 2010 -0400
> 
>     ACPI: handle systems which asynchoronously enable ACPI mode
>  
> So you can close the bug entry.

Thanks, closed.

Rafael
