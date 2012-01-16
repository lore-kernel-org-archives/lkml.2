Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab2APJWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 04:22:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41028 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592Ab2APJWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 04:22:07 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: dedekind1@gmail.com
Subject: Re: [PATCH] PM / MTD: Fix regressions related to mtd_suspend()
Date: Mon, 16 Jan 2012 10:23:45 +0100
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org
References: <201201151443.30897.rjw@sisk.pl> <201201160018.02305.rjw@sisk.pl> <1326705441.14299.10.camel@sauron.fi.intel.com>
In-Reply-To: <1326705441.14299.10.camel@sauron.fi.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201161023.45321.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 16. Januar 2012, 10:17:21 schrieb Artem Bityutskiy:
> Thanks Rafael!
> 
> I've pushed this patch to l2-mtd-2.6.git (David, would you please merge
> it upstream?).

Does this need to go into stable?

	Regards
		Oliver
