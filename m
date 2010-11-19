Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab0KSRvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 12:51:40 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:33011 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989Ab0KSRvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 12:51:38 -0500
Subject: Re: [PATCH v7 3/3] nl80211/mac80211: Report signal average
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: Bob Copeland <me@bobcopeland.com>, Jouni Malinen <j@w1.fi>,
        linville@tuxdriver.com, randy.dunlap@oracle.com, peterz@infradead.org,
        blp@cs.stanford.edu, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com,
        stefanr@s5r6.in-berlin.de, kosaki.motohiro@jp.fujitsu.com,
        akpm@linux-foundation.org, kevin.granade@gmail.com
In-Reply-To: <201011191749.31974.br1@einfach.org>
References: <20101112024901.28522.21895.stgit@localhost6.localdomain6>
	 <1290010595.3777.0.camel@jlt3.sipsolutions.net>
	 <AANLkTimoogSLAipNy=njGtHypqBQSk=usDmXut=KN9TM@mail.gmail.com>
	 <201011191749.31974.br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Nov 2010 09:52:31 -0800
Message-ID: <1290189151.3768.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 17:49 +0900, Bruno Randolf wrote:

> OK, I have done tests with a 266MHz x86 board, pushing 30Mbps UDP thru it. It 
> can handle maximum around 18Mbps thuput in both cases, with and without the 

That sounds like you're limited by 11g, not by the CPU ...

johannes

