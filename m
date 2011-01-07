Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab1AGW65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:58:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932Ab1AGW6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:58:53 -0500
Date: Fri, 7 Jan 2011 23:58:51 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Stephane Chatty <chatty@enac.fr>, Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v3 0/5] hid-multitouch: a first step towards multitouch
 unification 
In-Reply-To: <1294425762-29730-1-git-send-email-benjamin.tissoires@enac.fr>
Message-ID: <alpine.LNX.2.00.1101072355200.26685@pobox.suse.cz>
References: <1294425762-29730-1-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Jan 2011, Benjamin Tissoires wrote:

> Hi,
> 
> here is the v3.
> 
> all changes are coming from the mails with Henrik:
> 
> - restricted to new drivers only
> - delete mt_buffer struct
> - replace/adapt prev_valid in favor of seen_in_this_frame
> - integrated fuzz
> - introduce MT_QUIRKS
> - other small fixes

Hi Bejnamin,

thanks a lot for spinning this up so nicely and quickly.

I have now applied the patchset as-is to the 'multitouch' branch in my 
tree.

It doesn't currently build, as it depends on multitouch updates going 
through Dmitry's tree to Linus. As far as I have seen, Dmitry has already 
sent the pull request, but Linus hasn't pulled yet.
As soon as this happens, I will merge linux-2.6 into this branch to make 
it compilable.

I am planning to do two-round merging this merge window -- in the first 
round, I'll be pushing my current queue, and in the second round there 
will be hid-multitouch, in the first half of the next week, if everything 
goes smoothly.

Henrik, thanks a lot for the review, I really appreciate that.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
