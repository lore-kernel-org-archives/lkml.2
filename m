Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab2BEWfh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:35:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754745Ab2BEWfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:35:32 -0500
Date: Sun, 5 Feb 2012 17:35:27 -0500
From: Dave Jones <davej@redhat.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, linux-kernel@vger.kernel.org
Subject: Re: WARNING: at net/sched/sch_generic.c:256
 dev_watchdog+0x1f2/0x200()
Message-ID: <20120205223527.GA19001@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Justin P. Mattock" <justinmattock@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-kernel@vger.kernel.org
References: <20120205134050.7e135bb231b613806a2e0b70@gmail.com>
 <4F2F0065.9040909@lwfinger.net>
 <20120205142946.953cf9ed55b0adce3974a759@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120205142946.953cf9ed55b0adce3974a759@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 05, 2012 at 02:29:46PM -0800, Justin P. Mattock wrote:
 
 > > > [ 2270.546572] WARNING: at net/sched/sch_generic.c:256 dev_watchdog+0x1f2/0x200()
 > > > [ 2270.546576] Hardware name: 0914
 > > > [ 2270.546580] NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out
 > > 
 > > The error clearly comes from r8169, not from ath9k. If you unload r8169 before 
 > > suspending, does this still happen? My suspicion is that NM is getting confused.
 > > 
 > as a quick test I unloaded r8169 and did not see this message, but I also added it in and suspended
 > and no warning message as well.

FWIW, we've been seeing reports of this in Fedora since last summer.
https://bugzilla.redhat.com/show_bug.cgi?id=715137

(We have reports on other chips too, but this bug is just the r8169 reports)

	Dave

