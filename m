Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab1DNHB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 03:01:56 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34490 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab1DNHBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 03:01:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Subject: Re: cpusets: randomize node rotor used in cpuset_mem_spread_node()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        Jack Steiner <steiner@sgi.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Paul Menage <menage@google.com>,
        Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20110414065146.GA19685@tiehlicka.suse.cz>
References: <20110414111939.0812.A69D9226@jp.fujitsu.com> <20110414065146.GA19685@tiehlicka.suse.cz>
Message-Id: <20110414160145.0830.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Thu, 14 Apr 2011 16:01:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > mempolicy.c is no best place for putting generic nodemask utility function.
> > but unforunately we have no alternative. Gack.
> 
> Agreed. I was thinking about adding a new mm/numa.c but then I concluded
> that it would be overkill for the single function.

Agreed. Your choice is best in practical. I think. ;-)



