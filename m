Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab1GBMra (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 08:47:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49830 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347Ab1GBMr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 08:47:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Sat, 2 Jul 2011 14:48:22 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk,
        linux-usb@vger.kernel.org
References: <1309554818.2722.48.camel@mulgrave> <Pine.LNX.4.44L0.1107012200260.4273-100000@netrider.rowland.org> <20110702060846.GH23059@one.firstfloor.org>
In-Reply-To: <20110702060846.GH23059@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107021448.22616.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 02, 2011, Andi Kleen wrote:
> > I'm not able to reproduce it on a vanilla 3.0-rc5 system.  Can anybody
> > give the exact sequence of steps you went through to trigger the bug?
> 
> Connect USB storage device with builtin fake CD rom. Wait for udisk
> to mount it. Pull cable. udisk does umount. Oops.
> 
> I also got a log of the refcounting now if you want it.

Does reverting commit e1866b33b1e89f077b7132daae3dfd9a594e9a1a help?

Rafael
