Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab2EYWfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:35:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45613 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab2EYWf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:35:29 -0400
Date: Sat, 26 May 2012 00:35:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@redhat.com,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, tool: Add modifiers to be part of the event name
Message-ID: <20120525223528.GK27374@one.firstfloor.org>
References: <1336695468-5464-1-git-send-email-andi@firstfloor.org> <20120511102522.GA2012@m.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120511102522.GA2012@m.brq.redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 12:25:22PM +0200, Jiri Olsa wrote:
> On Thu, May 10, 2012 at 05:17:48PM -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > We need to save the original string for perf stat output,
> > otherwise :t and :c are invisible.
> 
> right, the modifier got lost
> 
> We need to fix the name once modifier is detected and final
> event name is assigned (e.g. there could be "*?" in the tracepoint
> event name, causing the name to be unwinded..).

What happened to this patch? Seems to be still broken in 3.4

-Andi
