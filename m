Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab1KCRI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:08:58 -0400
Received: from swift.blarg.de ([78.47.110.205]:56867 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755135Ab1KCRIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:08:55 -0400
X-Greylist: delayed 589 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Nov 2011 13:08:54 EDT
Date: Thu, 3 Nov 2011 17:59:03 +0100
From: Max Kellermann <max@duempel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] new cgroup controller "fork"
Message-ID: <20111103165903.GA4755@Debian-60-squeeze-64-minimal>
Mail-Followup-To: Glauber Costa <glommer@parallels.com>,
	linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
	Frederic Weisbecker <fweisbec@gmail.com>
References: <20111103162238.27609.11515.stgit@rabbit.intern.cm-ag>
 <4EB2C4A5.6000406@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB2C4A5.6000406@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011/11/03 17:43, Glauber Costa <glommer@parallels.com> wrote:
> I do have a couple of questions about this, but the most important
> one is: Is this a competing implementation, or a cooperative effort
> with Frederic's ?

Short answer: competing.

Long answer: I do not know Frederic's patch.  This is a repost of a
patch that I submitted 9 months ago:

 https://lkml.org/lkml/2011/2/17/116

After little discussion, nobody seemed to be interested in it, and
nobody merged it.  I reposted it today, not knowing somebody else had
come up with a similar idea meanwhile.

Max
