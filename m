Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab1C1LLD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 07:11:03 -0400
Received: from mail001.aei.ca ([206.123.6.130]:52782 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436Ab1C1LLA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 07:11:00 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Oliver Neukum <oneukum@suse.de>
Subject: Re: [Bug #28562] [BUG] usb problems in .38-rc3+
Date: Mon, 28 Mar 2011 07:10:52 -0400
User-Agent: KMail/1.13.6 (Linux/2.6.38.2-drm-crc+; KDE/4.6.1; x86_64; ; )
Cc: Chuck Ebbert <cebbert@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Mikko Vinni <mmvinni@yahoo.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, linux-usb@vger.kernel.org
References: <lDYNS4ATQ-N.A._aD.9m5jNB@chimera> <20110327205727.3abd06b5@katamari> <201103280955.48254.oneukum@suse.de>
In-Reply-To: <201103280955.48254.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103280710.53406.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 March 2011 03:55:48 Oliver Neukum wrote:
> Am Montag, 28. März 2011, 02:57:27 schrieb Chuck Ebbert:
> > On Sun, 27 Mar 2011 22:27:34 +0200 (CEST)
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28562
> > > Subject		: [BUG] usb problems in .38-rc3+
> > > Submitter	: Ed Tomlinson <edt@aei.ca>
> > > Date		: 2011-02-05 19:17 (51 days old)
> > > Message-ID	: <201102051417.58953.edt@aei.ca>
> > > References	: http://marc.info/?l=linux-kernel&m=129693391417607&w=2
> 
> Have you tested with USB autosuspend disabled?

Yes.  The problem is understood.  It can be bypassed by doing a 'hciconfig -a', which
puts the device in a state where it works.  As far as I know its not fixed yet.

See the thread: re "bluetooth disabled" and "[BUG] usb problems in .38-rc3+"

Thanks
Ed Tomlinson
