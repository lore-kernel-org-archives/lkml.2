Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933580Ab1KCRsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:48:08 -0400
Received: from bender.cm4all.net ([87.106.27.49]:41904 "EHLO bender.cm4all.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756168Ab1KCRsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:48:07 -0400
Date: Thu, 3 Nov 2011 18:48:09 +0100
From: Max Kellermann <mk@cm4all.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tim Hockin <thockin@hockin.org>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] new cgroup controller "fork"
Message-ID: <20111103174809.GA28108@rabbit.intern.cm-ag>
References: <20111103162238.27609.11515.stgit@rabbit.intern.cm-ag>
 <20111103164302.GE8198@somewhere.redhat.com>
 <20111103171645.GA27887@rabbit.intern.cm-ag>
 <4EB2CEB2.7050800@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB2CEB2.7050800@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011/11/03 18:26, Glauber Costa <glommer@parallels.com> wrote:
> On 11/03/2011 03:16 PM, Max Kellermann wrote:
> >but is different from my controller.
> >
> How so?

Once the "remaining" counter has reached zero, no further forks are
possible, no matter how many processes are left.  It is a fork
counter, not a process counter.

Let's say: Frederic's controller counts "things" that exists
(processes), and my controller counts "verbs" or "ations" (fork()).

Max
