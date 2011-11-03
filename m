Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934526Ab1KCTUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 15:20:41 -0400
Received: from swift.blarg.de ([78.47.110.205]:50759 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933862Ab1KCTUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 15:20:40 -0400
Date: Thu, 3 Nov 2011 20:20:39 +0100
From: Max Kellermann <max@duempel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] new cgroup controller "fork"
Message-ID: <20111103192039.GA5300@Debian-60-squeeze-64-minimal>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
	containers@lists.linux-foundation.org,
	Frederic Weisbecker <fweisbec@gmail.com>
References: <20111103162238.27609.11515.stgit@rabbit.intern.cm-ag>
 <4EB2C4A5.6000406@parallels.com>
 <20111103165903.GA4755@Debian-60-squeeze-64-minimal>
 <20111103182101.5037c1e5@lxorguk.ukuu.org.uk>
 <20111103185108.GA5153@Debian-60-squeeze-64-minimal>
 <20111103190330.02590426@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111103190330.02590426@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011/11/03 20:03, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> Sure - I'm just not seeing that a whole separate cgroup for it is
> appropriate or a good plan. Anyone doing real resource management needs
> the rest of the stuff anyway.

Right.  When I saw Frederic's controller today, my first thought was
that one could move the fork limit code over into that controller.  If
we reach a consensus that this would be a good idea, and would have
chances to get merged, I could probably take some time to refactor my
code.

Max
