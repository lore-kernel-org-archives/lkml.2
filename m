Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab1KOFtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 00:49:09 -0500
Received: from outmail148095.authsmtp.com ([62.13.148.95]:54346 "EHLO
	outmail148095.authsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751124Ab1KOFtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 00:49:07 -0500
X-Greylist: delayed 1915 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Nov 2011 00:49:07 EST
From: Ben Pfaff <blp@cs.stanford.edu>
To: jidanni@jidanni.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: Documentation/input/input.txt.gz has a bug
References: <8762im2n5f.fsf@jidanni.org>
Reply-To: Ben Pfaff <blp@cs.stanford.edu>
Date: Mon, 14 Nov 2011 21:13:08 -0800
In-Reply-To: <8762im2n5f.fsf@jidanni.org> (jidanni@jidanni.org's message of
	"Tue, 15 Nov 2011 09:24:28 +0800")
Message-ID: <87y5vihst7.fsf@blp.benpfaff.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Server-Quench: 04c5286f-0f49-11e1-97bb-002264978518
X-AuthReport-Spam: If SPAM / abuse - report it at: http://www.authsmtp.com/abuse
X-AuthRoute: OCdwYQ8QAVZfSBwy AThCFzNJTwsiPBEK DBMeOw5HJEYITQBc chwbOAMOd3sbWxYD A2cKS1RRWlx3U2d9 JQ1XcwRZfE5GQQdq UldLR1BXCwQmQW13 A2lFLWBycwBGenw+ ZkJkVj5bWBd/d057 FFNUQ2kPeGZhPWEC WUcKJR5UcAFIeBtM bVh6VXtDAzANdg4/ FBI2MjYtNCleLyIS QwcVME5VQEATAyJ6 WwAeWzo9VU0MXG06 ZxY7JTYA
X-Authentic-SMTP: 61633331373532.1014:706
X-AuthFastPath: 0 (Was 255)
X-AuthVirus-Status: No virus detected - but ensure you scan with your own anti-virus system.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jidanni@jidanni.org writes:

> /usr/share/doc/linux-doc-3.0.0/Documentation/input/input.txt.gz
> Has an error at "(c, 13, 32)" or needs an explanation added:
>
>   Doing a cat /dev/input/mouse0 (c, 13, 32) will verify that a mouse
> is also emulated, characters should appear if you move it.

I think that it's correct:

    $ ls -l /dev/input/mouse0
    crw------- 1 root root 13, 32 Nov 12 09:14 /dev/input/mouse0
-- 
Ben Pfaff 
http://benpfaff.org
