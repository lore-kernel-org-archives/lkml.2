Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934241Ab1KCRFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:05:42 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64501 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932995Ab1KCRFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:05:41 -0400
Date: Thu, 3 Nov 2011 18:05:37 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH] new cgroup controller "fork"
Message-ID: <20111103170532.GI8198@somewhere.redhat.com>
References: <20111103162238.27609.11515.stgit@rabbit.intern.cm-ag>
 <4EB2C4A5.6000406@parallels.com>
 <20111103165903.GA4755@Debian-60-squeeze-64-minimal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111103165903.GA4755@Debian-60-squeeze-64-minimal>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 05:59:03PM +0100, Max Kellermann wrote:
> On 2011/11/03 17:43, Glauber Costa <glommer@parallels.com> wrote:
> > I do have a couple of questions about this, but the most important
> > one is: Is this a competing implementation, or a cooperative effort
> > with Frederic's ?
> 
> Short answer: competing.
> 
> Long answer: I do not know Frederic's patch.  This is a repost of a
> patch that I submitted 9 months ago:
> 
>  https://lkml.org/lkml/2011/2/17/116
> 
> After little discussion, nobody seemed to be interested in it, and
> nobody merged it.  I reposted it today, not knowing somebody else had
> come up with a similar idea meanwhile.

Woops, sorry I never heard about it before I started working on this.
Otherwise I would have tried to work with you.
