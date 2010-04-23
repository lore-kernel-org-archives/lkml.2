Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101Ab0DWQ2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:28:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37236 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab0DWQ2t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:28:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas =?utf-8?q?M=C3=BCller?= <thomas@mathtm.de>
Subject: Re: [Bug #15719] virtio_net causing kernel BUG when running under VirtualBox
Date: Fri, 23 Apr 2010 18:29:03 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Rusty Russell <rusty@rustcorp.com.au>, Shirley Ma <mashirle@us.ibm.com>,
       Shirley Ma <xma@us.ibm.com>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <YeFfFNFyTSF.A.sRH.jRSzLB@tosh> <4BD1AA46.2050007@mathtm.de>
In-Reply-To: <4BD1AA46.2050007@mathtm.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004231829.04045.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 April 2010, Thomas Müller wrote:
> Fixed by commit 0e413f22e4c1cbfe12907e462a7d739a2e316f2b.

Thanks, closing.

Rafael


> On 20.04.2010 05:19, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.33.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15719
> > Subject		: virtio_net causing kernel BUG when running under VirtualBox
> > Submitter	: Thomas Müller <thomas@mathtm.de>
> > Date		: 2010-03-27 14:32 (24 days old)
> > First-Bad-Commit: http://kernel.org/git/linus/9ab86bbcf8be755256f0a5e994e0b38af6b4d399
> > Message-ID	: <4BAE1707.2050803@mathtm.de>
> > References	: http://marc.info/?l=linux-kernel&m=126970039227740&w=4
> > Handled-By	: Shirley Ma <mashirle@us.ibm.com>
> > 
> > 
> 
> 
> 

