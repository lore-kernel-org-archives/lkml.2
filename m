Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934925Ab0KQQP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 11:15:26 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:47725 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab0KQQPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 11:15:25 -0500
Subject: Re: [PATCH v7 3/3] nl80211/mac80211: Report signal average
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: Jouni Malinen <j@w1.fi>, linville@tuxdriver.com, randy.dunlap@oracle.com,
        peterz@infradead.org, blp@cs.stanford.edu,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars_Ericsson@telia.com, stefanr@s5r6.in-berlin.de,
        kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        kevin.granade@gmail.com
In-Reply-To: <201011171728.06801.br1@einfach.org>
References: <20101112024901.28522.21895.stgit@localhost6.localdomain6>
	 <20101112030035.28522.75318.stgit@localhost6.localdomain6>
	 <20101116093743.GA21872@jm.kir.nu>  <201011171728.06801.br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 08:16:35 -0800
Message-ID: <1290010595.3777.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 17:28 +0900, Bruno Randolf wrote:

> > Or am I missing something here and we have a compiler that is actually
> > able to take care of this kind of optimizations by itself in the current
> > ewma library design? Or is the unsigned long division with the expected
> > weight values going to be fast enough to not justify caring about it
> > even on any of the embedded boards anyway?
> 
> I understand that this could be more efficient, but if it matters or not - 
> honestly, I don't know. Can a more knowledgeable person than me comment on 
> this?

Yes, it does matter -- think of an embedded MIPS board running at 500MHz
and trying to push 11n speeds.

johannes

