Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab0H3RfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:35:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59479 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab0H3RfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:35:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [Bug #16505] 2.6.34.2 breaks b43
Date: Mon, 30 Aug 2010 19:34:19 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        archman <spermmail001@yahoo.com>
References: <c1_O4wHrlB.A.63.mbueMB@chimera> <ByD_7B96czP.A.h7B.DdueMB@chimera> <4C7AFE2C.1080204@lwfinger.net>
In-Reply-To: <4C7AFE2C.1080204@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008301934.19463.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 30, 2010, Larry Finger wrote:
> On 08/29/2010 06:13 PM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.34 and 2.6.35.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16505
> > Subject		: 2.6.34.2 breaks b43
> > Submitter	: archman <spermmail001@yahoo.com>
> > Date		: 2010-08-03 23:53 (27 days old)
> > Handled-By	: Larry Finger <Larry.Finger@lwfinger.net>
> > Patch		: https://bugzilla.kernel.org/attachment.cgi?id=27335
> 
> This one was fixed in 2.6.34.3. Mainline was OK - only the patches to stable
> were affected. The bug should be closed.

Thanks, closing.

Rafael
