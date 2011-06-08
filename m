Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab1FHQBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 12:01:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42656 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349Ab1FHQBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 12:01:31 -0400
Date: Wed, 8 Jun 2011 18:01:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] x86: Readd asmregparm
Message-ID: <20110608160128.GN27166@one.firstfloor.org>
References: <1307495401-2631-1-git-send-email-andi@firstfloor.org> <20110608081957.GA14966@elte.hu> <20110608083750.GH27166@one.firstfloor.org> <BANLkTimZ65o-gRf8n3SRzTedd=fTCB55QQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimZ65o-gRf8n3SRzTedd=fTCB55QQ@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> So from my point of view, none of the changelogs explain why the
> changes needed. Now, I'm not an expert on the x86 code so maybe I'm
> that you need it some unspecified follow-up patchkit. HTH.

Proper asmlinkages are imho a cleanliness feature that stands
on its own. They have been used in the past for all kinds of things,
but unfortunately have bitrotted recently on x86.

If nothing else they are useful documentation. For example
if you do grep for *.[ch] only and you hit an asmlinkage it's a good
hint to look into the .S too. In general you need to be much more
careful about any changes to those, because assembler is more fragile.

I have been encouraged by other people to post those early, so I did.
and at least in my traditional Linux development world view posting 
patches early is the right thing to do.

-Andi
