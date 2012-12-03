Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab2LCHsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 02:48:23 -0500
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:41318 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab2LCHsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 02:48:21 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlllAPlXvFBV5qjOPGdsb2JhbABEhUOFI7UZFwMBAQEBODSCHgEBBAE6HCMFCwgDRhQlChqIHQq+JxSQDGEDlgCFe41A
X-IronPort-AV: E=Sophos;i="4.83,361,1352070000"; 
   d="scan'208";a="456995792"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 3 Dec 2012 08:50:04 +0100
To: Kamal Mostafa <kamal@canonical.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Solda <dso@cypress.com>, Troy Abercrombia <ta@cypress.com>,
        Dudley Du <dudl@cypress.com>,
        Cypress Semiconductor Corporation <customercare@cypress.com>,
        Kyle Fazzari <git@status.e4ward.com>,
        Mario Limonciello <mario_limonciello@dell.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Herton Krzesinski <herton.krzesinski@canonical.com>
Subject: Re: [PATCH v3 0/4] Cypress PS/2 Trackpad driver
Message-ID: <20121203075004.GA2817@polaris.bitmath.org>
References: <1354226281-3476-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354226281-3476-1-git-send-email-kamal@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamal,

>   Patch #2 (main driver), as recommended by Henrik Rydberg[2]:
>   - use input_mt_assign_slots; drop cypress_cal_finger_id.
>   - enable 2-finger-only SEMI_MT; drop cypress_simulate_fingers.
>   - various code clean-ups.
> 
>   Henrik, does patch #2 appear to properly use assign_slots and SEMI_MT as
>   you intended?  This SEMI_MT method does work (with 2 finger support only),
>   but I'm not clear why we wouldn't want to handle >2 fingers also, so ...

It looks pretty good, please see the patch comments for details. As
Dmitry said, one can report the number of fingers separately from the
two guiding contacts, and this semi-mt behavior is well supported in
userspace.

> 
>   Patch #4 (new) reintroduces simulated multitouch for up to 5 fingers
>   (#if CYPRESS_SIMULATE_MT), disabling SEMI_MT again.
> 
>   If that functionality (support for >2 fingers) can be acheived in some
>   better way, please advise.

Yes, as above, so this patch will not be needed.

Thanks,
Henrik
