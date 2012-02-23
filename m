Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab2BWX3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 18:29:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39895 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755884Ab2BWX3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 18:29:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Miller <davem@davemloft.net>
Subject: Re: [Bug #42669] 3.3-rc1: compiling problems nvme , l2cap_sock , mc13892-regulator , and snd-pcsp don't work
Date: Fri, 24 Feb 2012 00:30:27 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
        maciej.rutecki@gmail.com, florian@mickler.org, w.landgraf@ru.ru
References: <y44pDJ8xoDC.A.08E.h8rRPB@chimera> <qCQH7HfZS8E.A.FVG.M9rRPB@chimera> <20120223.181904.501214130038312055.davem@davemloft.net>
In-Reply-To: <20120223.181904.501214130038312055.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202240030.27270.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 24, 2012, David Miller wrote:
> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Thu, 23 Feb 2012 23:51:25 +0100 (CET)
> 
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 3.2.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42669
> > Subject		: 3.3-rc1: compiling problems  nvme , l2cap_sock , mc13892-regulator , and snd-pcsp don't work
> > Submitter	: werner <w.landgraf@ru.ru>
> > Date		: 2012-01-20 18:52 (35 days old)
> > Message-ID	: <web-682421181@zbackend1.aha.ru>
> > References	: http://marc.info/?l=linux-kernel&m=132708923719565&w=2
> 
> The l2cap_sock problem is fixed in the net GIT tree by commit:

Thanks, closed.

Rafael
