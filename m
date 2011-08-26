Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab1HZJFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 05:05:16 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:57380 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753978Ab1HZJFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:05:06 -0400
Subject: Re: [PATCH] staging: brcmfmac: Consolidate debugging macros
From: Joe Perches <joe@perches.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        Kan Yan <kanyan@broadcom.com>, Greg KH <gregkh@suse.de>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
In-Reply-To: <CACna6ryfHpSkTtnyMUXShyZvN2quD3w8higymGGXfXsu3f1GEA@mail.gmail.com>
References: <927eab8b5c950c13991911cd4c16457a5d618bc7.1314252671.git.joe@perches.com>
	 <20110825154705.GA6567@kroah.com>
	 <CACna6ryfHpSkTtnyMUXShyZvN2quD3w8higymGGXfXsu3f1GEA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Aug 2011 02:05:04 -0700
Message-ID: <1314349504.9624.5.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-26 at 10:57 +0200, Rafał Miłecki wrote:
> 2011/8/25 Greg KH <greg@kroah.com>:
> > On Wed, Aug 24, 2011 at 11:16:48PM -0700, Joe Perches wrote:
> >> Convert multiple BRCMF_<debug_level> macros to a single
> >> brcmf_dbg(level, fmt, ...) macro.
[]
> >> Signed-off-by: Joe Perches <joe@perches.com>
> > Applied, thanks.
> You didn't give even 24h before applying :|
> (Unless this patch was already posted somewhere else with RFC?)

It's been posted before.
It was just updated to the brcmf_ prefix.

http://lkml.org/lkml/2011/5/18/324





