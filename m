Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab1KWMtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 07:49:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54745 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960Ab1KWMtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 07:49:43 -0500
Date: Wed, 23 Nov 2011 13:49:41 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] multitouch updates (mainly eGalax) 
In-Reply-To: <1322042074-3759-1-git-send-email-benjamin.tissoires@enac.fr>
Message-ID: <alpine.LNX.2.00.1111231348020.28728@pobox.suse.cz>
References: <1322042074-3759-1-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011, Benjamin Tissoires wrote:

> Here are some multitouch updates.
> Jiri, the first one is already in your upstream-fixes branch, but not in
> your for-next branch...

Hi Benjamin,

yes, that is intentional. 'upstream-fixes' branch is what is scheduled to 
be sent to Linus still during this development cycle (and therefore is not 
for linux-next).

Other branches get merged into linux-next, as they are scheduled for next 
merge window.

> Patch 0002 will help end-users to test their device without recompiling the
> hid-multitouch between each test.
> 
> Patches 0003-0008 are focused on eGalax: 
> * I made some cleanup in the #defines for the PIDS.
> * I removed the MT_QUIRK_EGALAX_XYZ_FIXUP as I understood why it was needed
> * I also removed the .maxcontact field in EGALAX as it is not necessary
>   (it was tested on 3 devices: Acer Iconia W500 by Marek, 0xa001 by Cedric,
>    and Windpad 110W by me)
> * I added a few new devices (I included the one reported by Marek and I kept
>   his "From")
> * I included the new protocol for a001 devices (reported by Cedric)

I will be queueing all those for 3.3, okay?

Thanks,

-- 
Jiri Kosina
SUSE Labs
