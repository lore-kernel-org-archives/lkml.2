Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab1GFHvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 03:51:53 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:6395 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab1GFHvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 03:51:52 -0400
Date: Wed, 6 Jul 2011 09:51:41 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-i2c@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        linux-kernel@vger.kernel.org,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Bonesio <bones@secretlab.ca>, Stephen Warren <SWarren@nvidia.com>
Subject: Re: [PATCH] i2c: Allow i2c_add_numbered_adapter() to assign a bus
 id.
Message-ID: <20110706095141.0daca2db@endymion.delvare>
In-Reply-To: <20110706063746.GA26611@ponder.secretlab.ca>
References: <20110627185505.19423.64214.stgit@ponder>
	<BANLkTi=6zxPUwGZ5JHhRGRHHaEgvNgiaHQ@mail.gmail.com>
	<20110705105330.63c113c8@endymion.delvare>
	<20110706063746.GA26611@ponder.secretlab.ca>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jul 2011 00:37:46 -0600, Grant Likely wrote:
> Actually, now that I'm looking at things, I don't think there will be
> a conflict.  Go ahead and take it via your tree so that I don't make
> Linus' life harder than it needs to be.

OK, I've added the patch to my quilt series for the time being, so
it'll be in linux-next. Let me know if you change your mind before I
send it to Linus during the 3.1 merge window.

-- 
Jean Delvare
