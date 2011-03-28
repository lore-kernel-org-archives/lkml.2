Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab1C1JwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 05:52:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51378 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab1C1JwJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 05:52:09 -0400
Subject: Re: [PATCH 2/5] Revert "oom: give the dying task a higher priority"
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Andrey Vagin <avagin@openvz.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
In-Reply-To: <20110324152757.GC1938@barrios-desktop>
References: <20110315153801.3526.A69D9226@jp.fujitsu.com>
	 <20110322194721.B05E.A69D9226@jp.fujitsu.com>
	 <20110322200657.B064.A69D9226@jp.fujitsu.com>
	 <20110324152757.GC1938@barrios-desktop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 28 Mar 2011 11:51:36 +0200
Message-ID: <1301305896.4859.8.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 00:27 +0900, Minchan Kim wrote:
> 
> At that time, I thought that routine is meaningless in non-RT scheduler.
> So I Cced Peter but don't get the answer.
> I just want to confirm it. 

Probably lost somewhere in the mess that is my inbox :/, what is the
full question?
