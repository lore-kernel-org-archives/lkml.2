Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab0LUUwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 15:52:21 -0500
Received: from tuxonice.net ([74.207.252.127]:39434 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab0LUUwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 15:52:20 -0500
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4D111381.5000609@tuxonice.net>
Date: Wed, 22 Dec 2010 07:52:17 +1100
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Power Management List <linux-pm@lists.osdl.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Trying to find a TuxOnIce merging plan that works.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael.

As you may recall, I started working on a bunch of patches about six 
months ago that have been very slow to get merged (yes, mostly my fault 
for perhaps being overly careful about testing). Unfortunately, in the 
process, you've merged other patches (the compression ones) that mean I 
have to rewrite what I'd already done.

To avoid this happening again, I'm proposing that I only work on one 
patch (or very small series of patches) at a time, and not start on the 
next one until you've merged the previous into your for-Linus tree. I'll 
keep an overall plan of where I intend to go, but take things very 
slowly so I don't waste time like that again.

The downside is that means I won't always be able to show demonstrably 
improvements immediately, but I guess we'll just have to cope with that 
situation. I guess I can mitigate this downside by explaining where I'm 
going, even if I can't provide numbers to prove it will be a real 
improvement.

Does this sound feasible to you?

Regards,

Nigel
