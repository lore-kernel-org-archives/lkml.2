Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab0JLCXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 22:23:43 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:38926 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab0JLCXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 22:23:42 -0400
Subject: RE: PROBLEM: brcm80211 hangs on 2.6.36-0.34.rc6.git3.fc15.x86_64
From: Jon Masters <jonathan@jonmasters.org>
To: Brett Rudley <brudley@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Henry Ptasinski <henryp@broadcom.com>, Nohee Ko <noheek@broadcom.com>,
        Jon Masters <jcm@jonmasters.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <7A94256FD72B884D9E7C55586C3CBCEE1382807E23@SJEXCHCCR01.corp.ad.broadcom.com>
References: <20101008065810.GA1680@constitution.bos.jonmasters.org>
	 <1286538243.21485.298.camel@constitution.bos.jonmasters.org>
	 <7A94256FD72B884D9E7C55586C3CBCEE1381EE4B69@SJEXCHCCR01.corp.ad.broadcom.com>
	 <1286827927.24745.7.camel@constitution.bos.jonmasters.org>
	 <7A94256FD72B884D9E7C55586C3CBCEE1382807E23@SJEXCHCCR01.corp.ad.broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Mon, 11 Oct 2010 22:22:10 -0400
Message-ID: <1286850130.30797.2.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-11 at 14:01 -0700, Brett Rudley wrote:

> > Yea. What about the high order bits in the phy msglevel, what are they
> > intended to be doing? 
> 
> Nothing special, wl_msg_level is a standard bitmap, each bit enables printfs
> for a particular feature. There is no special meaning attached to the
> location an individual bit within the word.

Good to know, I had interpreted it as having a different meaning.

> Yeah, it would be less confusing if they were redefined to be more compact,
> I'll fix that up.

No biggie. Thanks.

Jon.


