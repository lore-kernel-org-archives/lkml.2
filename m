Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab2JOHhC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 03:37:02 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:48998 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab2JOHhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 03:37:00 -0400
Date: Mon, 15 Oct 2012 09:36:44 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Ben Dooks <ben-linux@fluff.org>, Daniel Kurtz <djkurtz@chromium.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-i801: Add device tree support
Message-ID: <20121015093644.545af0ce@endymion.delvare>
In-Reply-To: <20120821082906.GC28886@pengutronix.de>
References: <1344409609-1904-1-git-send-email-thierry.reding@avionic-design.de>
	<20120821082906.GC28886@pengutronix.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2012 10:29:06 +0200, Wolfram Sang wrote:
> On Wed, Aug 08, 2012 at 09:06:47AM +0200, Thierry Reding wrote:
> > This commit adds support for probing slave devices parsed from the
> > device tree.
> > 
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> 
> Acked-by: Wolfram Sang <w.sang@pengutronix.de>
> 
> Jean, this one is for you, I guess?

Yes, sorry for the delay, applied.

-- 
Jean Delvare
