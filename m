Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab1G0GP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 02:15:57 -0400
Received: from outmail149120.authsmtp.net ([62.13.149.120]:61864 "EHLO
	outmail149120.authsmtp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751210Ab1G0GPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 02:15:55 -0400
X-Greylist: delayed 3698 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jul 2011 02:15:54 EDT
From: Ben Pfaff <blp@cs.stanford.edu>
To: Alan Ott <alan@signal11.us>
Cc: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: Re: IP over 802.2 with LLC/SNAP
References: <4E2F8B7B.80906@signal11.us>
Reply-To: Ben Pfaff <blp@cs.stanford.edu>
Date: Tue, 26 Jul 2011 22:13:01 -0700
In-Reply-To: <4E2F8B7B.80906@signal11.us> (Alan Ott's message of "Tue, 26 Jul
	2011 23:52:27 -0400")
Message-ID: <87wrf4ux0i.fsf@blp.benpfaff.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Server-Quench: 43a91605-b80f-11e0-97bb-002264978518
X-AuthReport-Spam: If SPAM / abuse - report it at: http://www.authsmtp.com/abuse
X-AuthRoute: OCdwYQ8QAVZfSBwy AThCFzNJTwsiPBEK DBMeOw5HJEYITQBc ch0bOAAMd38BQRYD A2cKS1RSWlx1U2J3 JQ1XcwRZfE5GQQdq UldLR1BXCwQmQRpj A2tvUktycgVHe38+ Y0RiVj5fXxVzdEB9 R1MGHW1QeGZhPWAC WUcKJR5UcAFIeBtM bVh6VXtDAzANdgMA VwgtMip5bW0Fbn4d XQARLRo2ZW1MJRgV f3g+
X-Authentic-SMTP: 61633331373532.1014:706
X-AuthFastPath: 0 (Was 255)
X-AuthVirus-Status: No virus detected - but ensure you scan with your own anti-virus system.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[I'm not sure that linux-net is an active list, are you looking
for netdev@vger.kernel.org?]

Alan Ott <alan@signal11.us> writes:

> So the question is, does Linux support IP over 802.2 with
> LLC/SNAP? 

No, I don't think that it does.  I tested this perhaps a year
ago, out of curiosity as much as anything else, and could not
find a way to make it work.

> Is there a sysfs/proc entry that I have to turn on to make this
> work (I didn't find one)?

I did not find one at the time.

I did find that one router on my company's network (I think it
was a Cisco) transformed the 802.2 LLC/SNAP headers into Ethernet
II headers as packets passed through it, which effectively acted
as a gateway to allow Linux to talk IP over 802.2 LLC/SNAP.  But
I don't think that it translated in the other direction.
-- 
Ben Pfaff 
http://benpfaff.org
