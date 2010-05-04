Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760216Ab0EDUfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 16:35:46 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:56200 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756954Ab0EDUfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 16:35:41 -0400
Date: Tue, 4 May 2010 22:19:22 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Marc Zyngier <maz@misterjones.org>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       thommycheck@gmail.com, dbaryshkov@gmail.com,
       Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de,
       linux-pcmcia@lists.infradead.org,
       kernel list <linux-kernel@vger.kernel.org>, utx@penguin.cz,
       lenz@cs.wisc.edu, omegamoon@gmail.com, eric.y.miao@gmail.com,
       zaurus-devel@www.linuxtogo.org,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: 2.6.34-rc6 regression: pcmcia no longer compiles
Message-ID: <20100504201922.GA16729@comet.dominikbrodowski.net>
Mail-Followup-To: Marc Zyngier <maz@misterjones.org>,
	Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	thommycheck@gmail.com, dbaryshkov@gmail.com,
	Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de,
	linux-pcmcia@lists.infradead.org,
	kernel list <linux-kernel@vger.kernel.org>, utx@penguin.cz,
	lenz@cs.wisc.edu, omegamoon@gmail.com, eric.y.miao@gmail.com,
	zaurus-devel@lists.linuxtogo.org,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
References: <20100504041448.GA2893@ucw.cz>
 <c79eb84d24e70983f4422c89a35580ff@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c79eb84d24e70983f4422c89a35580ff@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Does the attached patch fix it (compile-tested only)?

Yes, it looks good -- many thanks! Applied your patch to pcmcia-urgent.

Best,
	Dominik
