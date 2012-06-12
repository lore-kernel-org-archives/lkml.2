Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab2FLMgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 08:36:09 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45109 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab2FLMgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 08:36:08 -0400
Date: Tue, 12 Jun 2012 14:36:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Joe Perches <joe@perches.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, JBottomley@parallels.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next] hp100: delete VG/AnyLAN hp100
Message-ID: <20120612123600.GA2708@elf.ucw.cz>
References: <1337272841-25931-1-git-send-email-paul.gortmaker@windriver.com>
 <1337272841-25931-3-git-send-email-paul.gortmaker@windriver.com>
 <4FB52C99.6010303@windriver.com>
 <20120517212039.GC27789@windriver.com>
 <1337292547.8872.20.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337292547.8872.20.camel@joe2Laptop>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
On Thu 2012-05-17 15:09:07, Joe Perches wrote:
> On Thu, 2012-05-17 at 17:20 -0400, Paul Gortmaker wrote:
> > [Re: [PATCH 2/5] drivers/net: delete all code/drivers depending on CONFIG_MCA
> 
> If we're removing really old and unused stuff,
> how about the VG/AnyLAN driver too?

hp100... I believe it has PCI variants and I have that
somewhere. Please don't kill it.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
