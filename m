Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab0LGTSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 14:18:06 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:48645 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab0LGTSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 14:18:04 -0500
Subject: Re: [PATCH 3/3] nl80211/mac80211: Report signal average
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Bruno Randolf <br1@einfach.org>, randy.dunlap@oracle.com,
        br1@thinktube.com, peterz@infradead.org, blp@cs.stanford.edu,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars_Ericsson@telia.com, j@w1.fi, stefanr@s5r6.in-berlin.de,
        kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        kevin.granade@gmail.com
In-Reply-To: <20101207190631.GE2700@tuxdriver.com>
References: <20101202101231.22988.33396.stgit@localhost6.localdomain6>
	 <20101202101242.22988.56087.stgit@localhost6.localdomain6>
	 <20101207190631.GE2700@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 20:17:39 +0100
Message-ID: <1291749459.3607.56.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-07 at 14:06 -0500, John W. Linville wrote:
> On Thu, Dec 02, 2010 at 07:12:43PM +0900, Bruno Randolf wrote:
> > Extend nl80211 to report an exponential weighted moving average (EWMA) of the
> > signal value. Since the signal value usually fluctuates between different
> > packets, an average can be more useful than the value of the last packet.
> > 
> > This uses the recently added generic EWMA library function.
> > 
> > --
> > v2:	fix ABI breakage and change factor to be a power of 2.
> > 
> > Signed-off-by: Bruno Randolf <br1@einfach.org>
> 
> Jouni and Johannes, are you satisfied with this version?

Yeah, I think with the v2 of the lib improvement it should be fine.

johannes

