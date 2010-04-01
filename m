Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab0DAIJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 04:09:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37313
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754136Ab0DAIJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 04:09:02 -0400
Date: Thu, 01 Apr 2010 01:09:03 -0700 (PDT)
Message-Id: <20100401.010903.05627158.davem@davemloft.net>
To: fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [BUG] fault while using perf callchains in sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100401090608.GD5207@nowhere>
References: <20100329222132.GB12254@nowhere>
	<20100329.153208.190256896.davem@davemloft.net>
	<20100401090608.GD5207@nowhere>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 1 Apr 2010 11:06:11 +0200

> I actually can't. It works well on a backup 2.6.31-rc6 kernel
> but when I build a new one of this same version, the problem
> happens again. And I don't have the config of the one that works
> (and no /proc/config.gz as well).
> 
> So I suspect this is something that happens with some specific
> configs only.
> 
> Anyway, once I get more clues about this, I'll tell you.

I was going to ask you if any of your compiler tools changed
recently...

Check the gcc version printed by the working kernel at the top of the
dmesg logs and compare to what you end up using now.
