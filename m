Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab0KVTAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 14:00:38 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39392 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab0KVTAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 14:00:37 -0500
Date: Mon, 22 Nov 2010 13:46:34 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>, Bruno Randolf <br1@einfach.org>,
        randy.dunlap@oracle.com, br1@thinktube.com, peterz@infradead.org,
        blp@cs.stanford.edu, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com,
        stefanr@s5r6.in-berlin.de, kosaki.motohiro@jp.fujitsu.com,
        akpm@linux-foundation.org, kevin.granade@gmail.com
Subject: Re: [PATCH v7 3/3] nl80211/mac80211: Report signal average
Message-ID: <20101122184633.GD2117@tuxdriver.com>
References: <20101112024901.28522.21895.stgit@localhost6.localdomain6>
 <20101112030035.28522.75318.stgit@localhost6.localdomain6>
 <20101116093743.GA21872@jm.kir.nu>
 <1290193116.3768.8.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290193116.3768.8.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 10:58:36AM -0800, Johannes Berg wrote:
> On Tue, 2010-11-16 at 11:37 +0200, Jouni Malinen wrote:
> > On Fri, Nov 12, 2010 at 12:00:35PM +0900, Bruno Randolf wrote:
> > > Extend nl80211 to report an exponential weighted moving average (EWMA) of the
> > > signal value. Since the signal value usually fluctuates between different
> > > packets, an average can be more useful than the value of the last packet.
> > > 
> > > This uses the recently added generic EWMA library function.
> > 
> > Isn't that generic EWMA library function making this much more CPU
> > intensive than necessary?
> 
> John, is there any reason you completely ignored Jouni's feedback here?
> This wasn't addressed in v8.

Well, I confess that I didn't fully appreciate Jouni's point.

Is there any reason to presume that Bruno cannot (or will not) improve
the performance from here?  Do you have any measurement of the actual
performance impact?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
