Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab0LGTPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 14:15:36 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51687 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab0LGTPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 14:15:34 -0500
Date: Tue, 7 Dec 2010 14:06:31 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Bruno Randolf <br1@einfach.org>
Cc: randy.dunlap@oracle.com, br1@thinktube.com, peterz@infradead.org,
        blp@cs.stanford.edu, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com, j@w1.fi,
        stefanr@s5r6.in-berlin.de, kosaki.motohiro@jp.fujitsu.com,
        akpm@linux-foundation.org, kevin.granade@gmail.com,
        johannes@sipsolutions.net
Subject: Re: [PATCH 3/3] nl80211/mac80211: Report signal average
Message-ID: <20101207190631.GE2700@tuxdriver.com>
References: <20101202101231.22988.33396.stgit@localhost6.localdomain6>
 <20101202101242.22988.56087.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101202101242.22988.56087.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 07:12:43PM +0900, Bruno Randolf wrote:
> Extend nl80211 to report an exponential weighted moving average (EWMA) of the
> signal value. Since the signal value usually fluctuates between different
> packets, an average can be more useful than the value of the last packet.
> 
> This uses the recently added generic EWMA library function.
> 
> --
> v2:	fix ABI breakage and change factor to be a power of 2.
> 
> Signed-off-by: Bruno Randolf <br1@einfach.org>

Jouni and Johannes, are you satisfied with this version?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
