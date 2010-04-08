Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311Ab0DHUHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:07:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40975 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab0DHUHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:07:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [Bug #15718] File corruption regression on NFS related to commit 1f36f774
Date: Thu, 8 Apr 2010 22:10:21 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>
References: <6Pphclm24fK.A.lSF.qsPvLB@chimera> <JVS2s9dmTsP.A.ApF.zsPvLB@chimera> <4BBDC47E.1060405@panasas.com>
In-Reply-To: <4BBDC47E.1060405@panasas.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201004082210.21961.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 April 2010, Boaz Harrosh wrote:
> On 04/08/2010 12:13 AM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.33.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15718
> > Subject		: File corruption regression on NFS related to commit 1f36f774
> > Submitter	: Boaz Harrosh <bharrosh@panasas.com>
> > Date		: 2010-03-24 15:49 (15 days old)
> > First-Bad-Commit: http://git.kernel.org/git/linus/1f36f774b22a0ceb7dd33eca626746c81a97b6a5
> > Message-ID	: <4BAA3493.1030802@panasas.com>
> > References	: http://marc.info/?l=linux-kernel&m=126944579810350&w=4
> > Handled-By	: Al Viro <viro@zeniv.linux.org.uk>
> > 
> > 
> 
> Fix already in main line: 3e297b613491f0d4928aa652a2cd266aa06dc409
> 	Author: Al Viro <viro@zeniv.linux.org.uk>
> 	Restore LOOKUP_DIRECTORY hint handling in final lookup on open()

Thanks, closed.

Rafael
