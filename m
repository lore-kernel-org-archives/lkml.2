Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab0JOOh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:37:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51111 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166Ab0JOOhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:37:52 -0400
Date: Fri, 15 Oct 2010 16:37:50 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Philipp Merkel <mail@philmerk.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] hid: egalax: Rework to include joojoo support
In-Reply-To: <1286978302-30034-1-git-send-email-rydberg@euromail.se>
Message-ID: <alpine.LNX.2.00.1010151637050.6879@pobox.suse.cz>
References: <1286978302-30034-1-git-send-email-rydberg@euromail.se>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Oct 2010, Henrik Rydberg wrote:

> Hi Jiri, Stephane,
> 
> This series adds support for the joojoo tablet. Based on the
> jikos/egalax branch, the first two patches prepare for the change to
> MT slots. The third patch fixes the bug that was also fixed by commit
> f516611, but in another (agreed) way. The fourth patch fixes another
> minor problem. The fifth patch adds event filtering based on observed
> signal quality, and the sixth patch does the heavy lifting of
> converting to MT slots and thereby solving the major problem for the
> joojoo.
> 
> The patches have been tested on both supported devices. Thanks Philipp!
> 
> Henrik
> 
> Henrik Rydberg (6):
>   hid: egalax: Use kzalloc
>   hid: egalax: Setup input device manually
>   hid: egalax: Correct for device resolution report error
>   hid: egalax: Report zero as minimum pressure
>   hid: egalax: Add event filtering
>   hid: egalax: Convert to MT slots
> 
>  drivers/hid/hid-egalax.c |  177 +++++++++++++++++++++++++++-------------------
>  1 files changed, 103 insertions(+), 74 deletions(-)

Stephane, I'd appreciate if I could get your Acked-by: for the series. 

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
