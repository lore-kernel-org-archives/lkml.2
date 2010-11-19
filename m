Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab0KSS5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 13:57:17 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:49531 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab0KSS5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 13:57:16 -0500
Subject: Re: [PATCH v7 3/3] nl80211/mac80211: Report signal average
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Bruno Randolf <br1@einfach.org>, linville@tuxdriver.com,
        randy.dunlap@oracle.com, br1@thinktube.com, peterz@infradead.org,
        blp@cs.stanford.edu, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com,
        stefanr@s5r6.in-berlin.de, kosaki.motohiro@jp.fujitsu.com,
        akpm@linux-foundation.org, kevin.granade@gmail.com
In-Reply-To: <20101116093743.GA21872@jm.kir.nu>
References: <20101112024901.28522.21895.stgit@localhost6.localdomain6>
	 <20101112030035.28522.75318.stgit@localhost6.localdomain6>
	 <20101116093743.GA21872@jm.kir.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Nov 2010 10:58:36 -0800
Message-ID: <1290193116.3768.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 11:37 +0200, Jouni Malinen wrote:
> On Fri, Nov 12, 2010 at 12:00:35PM +0900, Bruno Randolf wrote:
> > Extend nl80211 to report an exponential weighted moving average (EWMA) of the
> > signal value. Since the signal value usually fluctuates between different
> > packets, an average can be more useful than the value of the last packet.
> > 
> > This uses the recently added generic EWMA library function.
> 
> Isn't that generic EWMA library function making this much more CPU
> intensive than necessary?

John, is there any reason you completely ignored Jouni's feedback here?
This wasn't addressed in v8.

johannes

