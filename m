Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab1K0L5O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 06:57:14 -0500
Received: from smtprelay0205.b.hostedemail.com ([64.98.42.205]:56818 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752596Ab1K0L5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 06:57:14 -0500
X-Panda: scanned!
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 2105
Date: Sun, 27 Nov 2011 11:57:12 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: rjw@sisk.pl
Cc: tino.keitel@tikei.de, linux-kernel@vger.kernel.org
Message-ID: <2103936926.165868.1322395032341.JavaMail.mail@webmail17>
References: <1718181782.740375.1322130615898.JavaMail.mail@webmail19>
 <20111124200553.GA13353@mac.home> <20111127110400.GA4672@mac.home>
 <201111271245.57772.rjw@sisk.pl>
Subject: Re: Re: [REGRESSION] [Linux 3.2] top/htop and all other CPU usage
 metering applications has gone crackers
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Webmail
X-Originating-IP: [46.146.42.45]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Nov 27, 2011, Rafael J. Wysocki <rjw@sisk.pl> wrote: 
> 
> On Sunday, November 27, 2011, Tino Keitel wrote:
> > On Thu, Nov 24, 2011 at 21:05:53 +0100, Tino Keitel wrote:
> > > On Thu, Nov 24, 2011 at 10:30:15 +0000, Artem S. Tashkinov wrote:
> > > > Hello,
> > > > 
> > > > I'd like to report a weird regression in Linux 3.2 (running rc3 now) - all CPU metering applications have gone terribly mad
> > > > under this kernel:
> > > 
> > > I get the same using top, htop and the gnome system monitor with kernel
> > > 3.2 on a Sandy Bridge quad core box, running Debian unstable.
> > 
> > I just tested 3.2-rc2, and see the same bug.
> 
> I'm seeing that too on one of my test boxes, but not all the time
> (i.e. there are periods in which the readings are correct).  The other boxes
> I've tested with 3.2-rc are fine in that respect.
> 
> Also, it seems that it shows 100%-(real load) when it is wrong.  So, it looks
> like there's an overflow somewhere in the CPU load measuring code, at least
> on some CPUs.
> 
> What's your CPU, BTW?

Intel Core i5 2500, i686

Best wishes,

Artem
