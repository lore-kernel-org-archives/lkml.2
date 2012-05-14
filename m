Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab2ENXzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 19:55:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37584 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720Ab2ENXzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 19:55:22 -0400
Date: Tue, 15 May 2012 01:55:17 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@redhat.com,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, tool: Add modifiers to be part of the event name
Message-ID: <20120514235517.GL27374@one.firstfloor.org>
References: <1336695468-5464-1-git-send-email-andi@firstfloor.org> <20120511102522.GA2012@m.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120511102522.GA2012@m.brq.redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please check attached patch.

Does not apply to Linus tree. I assume you want to fix it there -- 
after all it's a regression -- so do need a patch for that.

-Andi

