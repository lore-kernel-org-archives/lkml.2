Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab0H2XeN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 19:34:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55503 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240Ab0H2XeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 19:34:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [Bug #16173] After uncompressing the kernel, at boot time, the server hangs.
Date: Mon, 30 Aug 2010 01:28:34 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "David Hill" <hilld@binarystorm.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <c1_O4wHrlB.A.63.mbueMB@chimera> <ByD_7B96czP.A.vDE.diueMB@chimera> <m11v9hc8a1.fsf@fess.ebiederm.org>
In-Reply-To: <m11v9hc8a1.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008300128.34970.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 30, 2010, Eric W. Biederman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.34 and 2.6.35.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> >
> 
> Looks like it's fixed.

Good.  What mainlne commit is that?

Rafael


> "David Hill" <hilld@binarystorm.net> writes:
> > Date: Thu, 12 Aug 2010 23:09:52 -0700
> > 
> > Eureka!
> > 
> >    This seems to solve my problem!  My Dual P3-500MHZ is now booting with that
> > patch.
> > 
> > Good work guys!!!!
> > 
> > Thank you very much,
> 
> 
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16173
> > Subject		: After uncompressing the kernel, at boot time, the server hangs.
> > Submitter	: David Hill <hilld@binarystorm.net>
> > Date		: 2010-06-09 23:25 (82 days old)
> > First-Bad-Commit: http://git.kernel.org/linus/cf7500c0ea133d66f8449d86392d83f840102632
> > Handled-By	: Eric W. Biederman <ebiederm@xmission.com>
> 
> 

