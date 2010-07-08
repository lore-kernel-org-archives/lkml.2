Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab0GHJoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 05:44:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42239 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab0GHJon convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 05:44:43 -0400
Subject: Re: [PATCH] futex: futex_find_get_task remove credentails check
From: Peter Zijlstra <peterz@infradead.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <20100708093919.GC4925@tiehlicka.suse.cz>
References: <20100628155845.GC24127@tiehlicka.suse.cz>
	 <20100628163952.GD24127@tiehlicka.suse.cz>
	 <1277743748.3561.139.camel@laptop>
	 <20100629084230.GE6215@tiehlicka.suse.cz>
	 <AANLkTinyoyZVg8iYOuUx6aA4XlUlLywl4q6GLXmeYP-x@mail.gmail.com>
	 <20100630070115.GB3890@tiehlicka.suse.cz>
	 <20100630095525.GA5840@tiehlicka.suse.cz> <4C2B742F.6050403@us.ibm.com>
	 <20100708092819.GB4925@tiehlicka.suse.cz> <20100708093241.GB6057@elte.hu>
	 <20100708093919.GC4925@tiehlicka.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 08 Jul 2010 11:43:53 +0200
Message-ID: <1278582233.1900.22.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 11:39 +0200, Michal Hocko wrote:
> OK, so do you need an ACK from Thomas, or can you grab the patch and
> push it through one of your trees?
> 
Have a look at Linus' tree.
