Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759867Ab2D0IxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:53:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37523 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757634Ab2D0IxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:53:09 -0400
Date: Fri, 27 Apr 2012 10:53:06 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>
Subject: Re: [PATCH 1/3] hid-hyperv: Do not use hid_parse_report() directly
In-Reply-To: <1335097300-11881-2-git-send-email-rydberg@euromail.se>
Message-ID: <alpine.LNX.2.00.1204271052330.1856@pobox.suse.cz>
References: <1335097300-11881-1-git-send-email-rydberg@euromail.se> <1335097300-11881-2-git-send-email-rydberg@euromail.se>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Apr 2012, Henrik Rydberg wrote:

> Upcoming changes will split the semantics of hid_parse_report()
> and hid_parse(), so make sure drivers use hid_parse() in probe().
> 
> Compiled, not tested.
> 
> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

KY, could I please get your Ack/Tested-by for this patch?

Thanks,

-- 
Jiri Kosina
SUSE Labs
