Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab1CAXSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 18:18:42 -0500
Received: from deadhat.com ([71.245.97.202]:52460 "EHLO deadhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757067Ab1CAXSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 18:18:41 -0500
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Mar 2011 18:18:41 EST
Message-ID: <ded07e5c09d72da478c6218658095f5a.squirrel@deadhat.com>
Date: Tue, 1 Mar 2011 14:49:28 -0800
Subject: Why is my copyright code in the linux kernel?
From: dj@deadhat.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.20
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was surprised to find code that is mine in Linux.

Following the advice in the REPORTING_BUGS file, I'm sending this email
here, for want of knowledge of a better contact.

In 2002, I published code at www.deadhat.com to generate cryptographic
vectors to aid in the development of IEEE 802.11i, a spec for which I was
a contributor.

One example can be found here:
http://www.deadhat.com/wlancrypto/ccm1.2.c

You will see a remarkable resemblance to parts of
linux-2.6.36.2/drivers/staging/rt2860/common/cmm_aes.c. E.G. the AES code,
the MIC header code and some ancillary functions.

However my header with my name and copyright has been removed. A different
copyright has been added and it has been licensed under the GPL without my
knowledge.

I am a happy user of Linux, I don't want to cause trouble and I'd be quite
honored to have some of my code in the kernel, so I'm not demanding the
immediate removal of this code. I'm willing to GPL my code if necessary,
but I do require proper attribution and acknowledgment of my copyright on
my code

I'd like to know who is an appropriate person to discuss this with.

Thank you,
David Johnston
dj@deadhat.com

