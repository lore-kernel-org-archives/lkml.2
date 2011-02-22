Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab1BVT6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 14:58:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48580 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890Ab1BVT6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 14:58:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ed Tomlinson <edt@aei.ca>
Subject: Re: [Bug #28562] [BUG] usb problems in .38-rc3+
Date: Tue, 22 Feb 2011 20:57:47 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc5+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <xmAo3o4v0VF.A.eLH.HWtYNB@chimera> <5HY1m9_-mkI.A.VxH.8WtYNB@chimera> <201102212106.07392.edt@aei.ca>
In-Reply-To: <201102212106.07392.edt@aei.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102222057.47321.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 22, 2011, Ed Tomlinson wrote:
> On Monday 21 February 2011 17:03:00 Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.37.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28562
> > Subject		: [BUG] usb problems in .38-rc3+
> > Submitter	: Ed Tomlinson <edt@aei.ca>
> > Date		: 2011-02-05 19:17 (17 days old)
> > Message-ID	: <201102051417.58953.edt@aei.ca>
> > References	: http://marc.info/?l=linux-kernel&m=129693391417607&w=2
>  
> I figured out a work around for this.  Once the bluetooth adaptor has been detected and udev
> had done its stuff run: 
> 
> hciconfig -a
> 
> With this user space change it works.  I have no idea why the 'hciconfig -a' query fixes things.
> I run gentoo and bluez-4.87 is installed.

OK, thanks for the update.  Do I understand correctly that things used to work
before without that workaround?

Rafael
