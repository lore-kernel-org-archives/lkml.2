Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab2GJKMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 06:12:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58446 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120Ab2GJKMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 06:12:03 -0400
Date: Tue, 10 Jul 2012 12:11:55 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Input: bcm5974 - Add support for 2012 MacBook Pro
 Retina
In-Reply-To: <1341838006-22407-2-git-send-email-rydberg@euromail.se>
Message-ID: <alpine.LRH.2.00.1207101211070.16114@twin.jikos.cz>
References: <1341838006-22407-1-git-send-email-rydberg@euromail.se> <1341838006-22407-2-git-send-email-rydberg@euromail.se>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2012, Henrik Rydberg wrote:

> Add support for the 15'' MacBook Pro Retina model (MacBookPro10,1).
> 
> Patch originally written by clipcarl (forums.opensuse.org).
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> Hi Dmitry,
> 
> Here is a patch for the new retina I picked up from the anonymous
> heroes on the linux forums. Looks simple enough for 3.5 to me.  Either
> way, the usual sync with Jiri is needed.

	Acked-by: Jiri Kosina <jkosina@suse.cz> 

for "[PATCH 1/2] HID: Add support for 2012 MacBook Pro Retina". Dmitry, 
please either take that through your tree, or send me your Ack for this 
one and I'll take it.

Thanks,

-- 
Jiri Kosina
SUSE Labs

