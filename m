Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449Ab0KVCgv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 21:36:51 -0500
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:29396 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756150Ab0KVCgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 21:36:50 -0500
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v7 3/3] nl80211/mac80211: Report signal average
Date: Mon, 22 Nov 2010 11:36:49 +0900
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; x86_64; ; )
Cc: Bob Copeland <me@bobcopeland.com>, Jouni Malinen <j@w1.fi>,
        linville@tuxdriver.com, randy.dunlap@oracle.com, peterz@infradead.org,
        blp@cs.stanford.edu, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com,
        stefanr@s5r6.in-berlin.de, kosaki.motohiro@jp.fujitsu.com,
        akpm@linux-foundation.org, kevin.granade@gmail.com
References: <20101112024901.28522.21895.stgit@localhost6.localdomain6> <201011191749.31974.br1@einfach.org> <1290189151.3768.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1290189151.3768.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011221136.49317.br1@einfach.org>
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat November 20 2010 02:52:31 Johannes Berg wrote:
> On Fri, 2010-11-19 at 17:49 +0900, Bruno Randolf wrote:
> > OK, I have done tests with a 266MHz x86 board, pushing 30Mbps UDP thru
> > it. It can handle maximum around 18Mbps thuput in both cases, with and
> > without the
> 
> That sounds like you're limited by 11g, not by the CPU ...

Nope. I forgot to mention that I was testing in A mode and I expect 30Mbps 
thruput here (I get that consistently on other boards). Also I see my CPU is 
at 100% with top.

bruno
