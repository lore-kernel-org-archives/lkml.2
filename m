Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933938Ab0FRU0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 16:26:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43141
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933510Ab0FRU0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 16:26:44 -0400
Date: Fri, 18 Jun 2010 13:26:55 -0700 (PDT)
Message-Id: <20100618.132655.260090086.davem@davemloft.net>
To: jbarnes@virtuousgeek.org
Cc: rjw@sisk.pl, mikpe@it.uu.se, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, maciej.rutecki@gmail.com
Subject: Re: [Bug #16161] [2.6.35-rc1 regression] sysfs: cannot create
 duplicate filename ... XVR-600 related?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100618131049.462ca7ce@virtuousgeek.org>
References: <19475.45707.157935.788004@pilspetsen.it.uu.se>
	<201006122052.25204.rjw@sisk.pl>
	<20100618131049.462ca7ce@virtuousgeek.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Fri, 18 Jun 2010 13:10:49 -0700

> I reverted the symlink patch that was causing the trouble.  The root
> cause is elsewhere though; it seems some firmwares report duplicate PCI
> slot numbers...

Instead of postulating, you can confirm or deny such a theory
by taking a look at the repository of sparc openfirmware tree
dumps maintained at:

	master.kernel.org:/pub/scm/linux/kernel/git/davem/prtconfs.git
