Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab0D0UY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 16:24:29 -0400
Received: from pqueuea.post.tele.dk ([193.162.153.9]:48694 "EHLO
	pqueuea.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab0D0UY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 16:24:28 -0400
Date: Tue, 27 Apr 2010 22:24:03 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Nicolas Palix <npalix@diku.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
       "David S. Miller" <davem@davemloft.net>, Michal Marek <mmarek@suse.cz>,
       Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       cocci@diku.dk
Subject: Re: [PATCH 1/4] Add targets to use the Coccinelle checker
Message-ID: <20100427202403.GA25722@merkur.ravnborg.org>
References: <1272316279-12042-1-git-send-email-npalix@diku.dk> <1272316279-12042-2-git-send-email-npalix@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272316279-12042-2-git-send-email-npalix@diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hej Nicolas.

On Mon, Apr 26, 2010 at 11:11:16PM +0200, Nicolas Palix wrote:
> Four targets are added. Each one generates a different
> output kind: context, patch, org, report.
> Every SmPL file in 'scripts/smpl' is given to the spatch frontend
> (located in the 'scripts' directory), and applied to the entire
> source tree.

For outsiders smpl does not rellate to coccinelle.

I suggest to consistently use the name of the tool in all places.

So smpl directory to be named coccinelle
SPATCH named coccinelle
spatch.sh named coccinelle.sh
etc.

This way we use one name for one thing. And not today where you
use three names for the same thing.
The files may be named *.smpl - because their home in

    scripts/coccinelle/

will tell what they are used for.

[I regret that I used CHECK to name the sparse tool].

	Sam
