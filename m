Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab2LBVtl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 16:49:41 -0500
Received: from void.printf.net ([89.145.121.20]:33761 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277Ab2LBVtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 16:49:39 -0500
From: Chris Ball <cjb@laptop.org>
To: NeilBrown <neilb@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, lkml <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH] SDIO / PM: Add empty bus-level suspend/resume callbacks
References: <20120325203849.7a908e32@notabene.brown>
	<201203260029.24826.rjw@sisk.pl>
	<20121202194625.5d66e239@notabene.brown>
	<2147450.LFoExqrKEF@vostro.rjw.lan>
	<20121203065457.0bd12fc6@notabene.brown>
Date: Sun, 02 Dec 2012 16:49:32 -0500
In-Reply-To: <20121203065457.0bd12fc6@notabene.brown> (NeilBrown's message of
	"Mon, 3 Dec 2012 06:54:57 +1100")
Message-ID: <87y5hgcefn.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Dec 02 2012, NeilBrown wrote:
>> What about applying the appended patch (hopefully, the build warnings should
>> be fixed properly this time)?
>
> Looks good to me - thanks!

Thanks, both of you, pushed to mmc-next for 3.8.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
