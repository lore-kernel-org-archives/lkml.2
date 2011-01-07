Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab1AGUJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 15:09:47 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:44477 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752552Ab1AGUJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 15:09:46 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 7 Jan 2011 21:08:50 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Stephane Chatty <chatty@enac.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v3 0/5] hid-multitouch: a first step towards multitouch
 unification
Message-ID: <20110107200850.GE29913@polaris.bitmath.org>
References: <1294425762-29730-1-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294425762-29730-1-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PbIcE-0003ni-Cc.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PbIcE-0003ni-Cc 18b3ec2d0fd8c029e5036521b9276baf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

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

A lot of progress in one day - thank you very much for making the
changes. I will be online for quite a bit longer in case there is more
coming this way. With some testing over the weekend (I will be
traveling, sorry), it doesn't look impossible to have this ready early
next week.

Cheers,
Henrik
