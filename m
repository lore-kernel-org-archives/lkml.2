Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab1AFPeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 10:34:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36921 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042Ab1AFPeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 10:34:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jan Kara <jack@suse.cz>
Subject: Re: [Bug #21092] Kernel 2.6.36 Bug during quotaon on reiserfs
Date: Thu, 6 Jan 2011 16:33:17 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, markus.gapp@gmx.net
References: <odW4v9b6arG.A.2bH.uE8GNB@chimera> <LbeBv-BNQpL.A.aM.5F8GNB@chimera> <20110106105424.GC4641@quack.suse.cz>
In-Reply-To: <20110106105424.GC4641@quack.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101061633.17471.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 06, 2011, Jan Kara wrote:
>   Hi,
> 
> On Thu 30-12-10 00:21:21, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.35 and 2.6.36.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.35 and 2.6.36.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=21092
> > Subject		: Kernel 2.6.36 Bug during quotaon on reiserfs
> > Submitter	:  <markus.gapp@gmx.net>
> > Date		: 2010-10-24 16:57 (67 days old)
> > Handled-By	: Jan Kara <jack@suse.cz>
> > Patch		: https://bugzilla.kernel.org/attachment.cgi?id=35292
>   As far as I know, the problem has been fixed by commit
> da905873effecd1c0166e578bc4b5006f041b18b in the end.

Thanks, closing.

Rafael
