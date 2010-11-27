Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab0K0NGX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 08:06:23 -0500
Received: from blade3.isti.cnr.it ([194.119.192.19]:60522 "EHLO
	BLADE3.ISTI.CNR.IT" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab0K0NGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 08:06:22 -0500
Date: Sat, 27 Nov 2010 14:07:22 +0100
From: Spelic <spelic@shiftmail.org>
Subject: Can't find fourth number version tags in GIT kernel
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-id: <4CF1028A.6010401@shiftmail.org>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7bit
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11)
 Gecko/20100713 Thunderbird/3.0.6
X-INSM-ip-source: 151.83.169.202 Auth Done
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello LKML
I'm trying to use GIT to stay up-to-date with the kernel sources, but in

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
and even
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.36.y.git

I can't find versions with four numbers, e.g. I do find tag:

v2.6.35
(and also the release candidates for 2.6.35)

but I can't find tags:

v2.6.35.1
v2.6.35.2
...
v2.6.35.9

Apparently tag v2.6.35 really brings me to v2.6.35.0 and not to 
v2.6.35.9 so it's a problem... I usually want to get the highest number 
in the fourth number, not the lowest.
Like this I don't know how to get the bugfixes...?

What am I missing?

Thank you
PS: can you please reply to me also, as I am not subscribed to LKML. Thanks
