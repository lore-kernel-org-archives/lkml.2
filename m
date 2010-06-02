Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab0FBJI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 05:08:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54193
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754322Ab0FBJI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 05:08:26 -0400
Date: Wed, 02 Jun 2010 02:08:36 -0700 (PDT)
Message-Id: <20100602.020836.25148560.davem@davemloft.net>
To: achiang@canonical.com
Cc: mikpe@it.uu.se, linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [2.6.35-rc1 regression] sysfs: cannot create duplicate
 filename ... XVR-600 related?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100602030925.GA3402@canonical.com>
References: <19461.26166.427857.612983@pilspetsen.it.uu.se>
	<20100601.153105.90813554.davem@davemloft.net>
	<20100602030925.GA3402@canonical.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Chiang <achiang@canonical.com>
Date: Tue, 1 Jun 2010 21:09:25 -0600

> Does sparc64 load any PCI hotplug drivers?

Never.  And everything and all PCI controllers and devices are probed
and registered at boot time.
