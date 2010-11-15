Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab0KONvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 08:51:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35899 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755697Ab0KONvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 08:51:04 -0500
Date: Mon, 15 Nov 2010 14:51:03 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Stefan Achatz <stefan_achatz@web.de>,
        "Eric W. Biederman" <ebiederm@aristanetworks.com>,
        "Serge E. Hallyn" <serue@us.ibm.com>, Tejun Heo <tj@kernel.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Thery <benjamin.thery@bull.net>
Subject: Re: [PATCH 1/2] sysfs: Introducing sysfs_create_bin_group()
In-Reply-To: <alpine.LNX.2.00.1011151447070.7420@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1011151450140.7420@pobox.suse.cz>
References: <1289585918.2629.12.camel@neuromancer> <20101112192958.GA22233@suse.de> <20101112193817.GA1299@core.coreip.homeip.net> <20101112195010.GA23000@suse.de> <20101112200215.GD1299@core.coreip.homeip.net>
 <alpine.LNX.2.00.1011151447070.7420@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010, Jiri Kosina wrote:

> > Those Europeans with their long vacations, geeze... Well, I hope he's
> > having fun ;)
> 
> Oh definitely. We haven't expected snow and ice already being there in 
> White Mountain :) Quite a fun.
> 
> sysfs_create_bin_group() definitely looks like an improvement. I'd like to 
> take it together with the Roccat driver patch, as it depends on it. Greg 
> -- would you mind me taking it through my tree with your signoff?

Ah, now I see the other thread with the raciness point. Stefan, have you 
already done some progress in this direction?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
