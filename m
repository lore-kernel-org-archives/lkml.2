Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab1A0Bti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 20:49:38 -0500
Received: from trent.utfs.org ([194.246.123.103]:48446 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413Ab1A0Bth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 20:49:37 -0500
Date: Wed, 26 Jan 2011 17:49:35 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Thomas Meyer <thomas@m3y3r.de>
cc: walt <w41ter@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.37-08009-ge6f597a "feels" slow - rhythmbox skips audio
In-Reply-To: <1295695038.2120.6.camel@localhost.localdomain>
Message-ID: <alpine.DEB.2.01.1101261748330.7903@trent.utfs.org>
References: <1295395790.3327.9.camel@localhost.localdomain>  <ih73o4$gnf$1@dough.gmane.org> <1295695038.2120.6.camel@localhost.localdomain>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Jan 2011 at 12:17, Thomas Meyer wrote:
> Yes, I *had* SCHED_AUTOGROUP enabled. After disabling it, the machine is
> back to normal speed.

Have a look at http://www.gossamer-threads.com/lists/linux/kernel/1330723
...does it help?

C.
-- 
BOFH excuse #436:

Daemon escaped from pentagram
