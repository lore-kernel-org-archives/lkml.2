Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab1CQK0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 06:26:04 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:6769 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab1CQK0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 06:26:01 -0400
Date: Thu, 17 Mar 2011 11:25:30 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Wolfram Sang <w.sang@pengutronix.de>, Dirk Eibach <eibach@gdsys.de>,
        devicetree-discuss@lists.ozlabs.org, rdunlap@xenotime.net,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] hwmon: (ads1015) Add devicetree documentation
Message-ID: <20110317112530.50dc4915@endymion.delvare>
In-Reply-To: <AANLkTikXzJEAYg7+5ekMzTj_V-Hs63Psgru4Vc_QGhRy@mail.gmail.com>
References: <1299143805-13133-1-git-send-email-eibach@gdsys.de>
	<20110303115151.GF3649@pengutronix.de>
	<20110303132025.51e0d92e@endymion.delvare>
	<20110303132549.GG3649@pengutronix.de>
	<20110303172653.GB22940@angua.secretlab.ca>
	<20110303230253.0e8455c2@endymion.delvare>
	<AANLkTikXzJEAYg7+5ekMzTj_V-Hs63Psgru4Vc_QGhRy@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Mar 2011 15:09:28 -0700, Grant Likely wrote:
> On Thu, Mar 3, 2011 at 3:02 PM, Jean Delvare <khali@linux-fr.org> wrote:
> > I will leave it up to Dirk to decide how much time he wants to spend on
> > this. He has already been very patient with the driver review process
> > and I do not want to abuse his patience.
> 
> BTW Dirk, I'm happy to help show how to write the parser code for the
> sub-node approach if you need it.

Grant, Wolfram, how are such patches committed? Documentation/devicetree/
isn't listed in MAINTAINERS. Is it OK for me to commit it once Dirk gets
your approval? Or do you prefer to commit it yourself?

-- 
Jean Delvare
