Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab2CZT5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 15:57:45 -0400
Received: from void.printf.net ([89.145.121.20]:44704 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab2CZT5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 15:57:43 -0400
From: Chris Ball <cjb@laptop.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@vger.kernel.org>,
        NeilBrown <neilb@suse.de>, lkml <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH] PM / SDIO: Use empty system suspend/resume callbacks at the bus level
References: <20120325203849.7a908e32@notabene.brown>
	<20120326084515.0fd3ee7f@notabene.brown>
	<201203260029.24826.rjw@sisk.pl> <201203262159.09335.rjw@sisk.pl>
Date: Mon, 26 Mar 2012 15:57:43 -0400
In-Reply-To: <201203262159.09335.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Mon, 26 Mar 2012 21:59:09 +0200")
Message-ID: <87vclrxhhk.fsf@laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Mon, Mar 26 2012, Rafael J. Wysocki wrote:
> OK, I don't see any objections.  Does it mean I can push this patch as a fix
> for 3.4?  Chris?

Sounds good, I'll push it through the MMC tree.  (With a stable@ tag for
3.3 to fix the regression there.)

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
