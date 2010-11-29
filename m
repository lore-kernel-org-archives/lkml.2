Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab0K2LuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 06:50:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43431 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454Ab0K2LuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 06:50:07 -0500
Date: Mon, 29 Nov 2010 12:50:05 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Philipp Merkel <mail@philmerk.de>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] hid: egalax: Rework to include Joojoo and Wetab
 support
In-Reply-To: <1291016612-25102-1-git-send-email-rydberg@euromail.se>
Message-ID: <alpine.LNX.2.00.1011291248290.981@pobox.suse.cz>
References: <1291016612-25102-1-git-send-email-rydberg@euromail.se>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Nov 2010, Henrik Rydberg wrote:

> Hi Jiri,
> 
> This is the second version of this patchset, extended to also support
> the Wetab. The input core changes aside, the patches provide exactly
> the same changes, except for a better signal-to-noise value provided
> by Phillip.
> 
> The first patch is already in your tree, but provided for completeness
> (the present set is against -rc3). The second patch no longer sets up
> the events per packet, since it is handled during slots
> initialization. The third and fourth patch are identical, the fifth
> has that new value, and the sixth is further simplified by using the
> new input core interface. The seventh patch adds support for the
> Wetab.
> 
> The driver has been tested succesfully on all three supported device
> ids.
> 
> Cheers,
> Henrik
> 
> Henrik Rydberg (7):
>   hid: egalax: Use kzalloc
>   hid: egalax: Setup input device manually (rev2)
>   hid: egalax: Correct for device resolution report error (rev2)
>   hid: egalax: Report zero as minimum pressure (rev2)
>   hid: egalax: Add event filtering (rev3)
>   hid: egalax: Convert to MT slots (rev2)
>   hid: egalax: Add support for Wetab
> 
>  drivers/hid/hid-core.c   |    1 +
>  drivers/hid/hid-egalax.c |  129 +++++++++++++++++++---------------------------
>  drivers/hid/hid-ids.h    |    1 +
>  3 files changed, 56 insertions(+), 75 deletions(-)

>From a quick look, it looks basically fine to me, thanks!

Just a very minor nit: it'd be nice to have the Kconfig help text entry 
updated, as the eGalax driver now supports more than what is described 
there.

How are we going to handle this? Dmitry, what is your plan with input-mt 
slots changes?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
