Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab2J2JXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 05:23:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:46194 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab2J2JXt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 05:23:49 -0400
Message-ID: <1351502608.24721.2.camel@twins>
Subject: Re: [PATCH 31/33] perf, tools: Support generic events as pmu event
 names v2
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        acme@redhat.com, eranian@google.com, mingo@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Date: Mon, 29 Oct 2012 10:23:28 +0100
In-Reply-To: <20121028191243.GO16230@one.firstfloor.org>
References: <1351283415-13170-1-git-send-email-andi@firstfloor.org>
	 <1351283415-13170-32-git-send-email-andi@firstfloor.org>
	 <20121027194200.GD1039@krava.redhat.com>
	 <20121028191243.GO16230@one.firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-10-28 at 20:12 +0100, Andi Kleen wrote:
> 
> Note I wrote and posted all this before you posted last week, but the wheels
> of perf review grind so slowly that you overtook me.
> 
> Peter Z., to be honest all these later patches are just caused by not having
> generic TSX events/modifiers and you not liking my original approach.

He posted his patches first in June, your haswell stuff came in Sep, you
completely ignored his sysfs work, your problem.
