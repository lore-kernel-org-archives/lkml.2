Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab0FWPeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 11:34:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40544 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab0FWPeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 11:34:11 -0400
Date: Wed, 23 Jun 2010 17:34:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] security: Yama LSM
Message-ID: <20100623153408.GA15787@basil.fritz.box>
References: <20100623065236.GH5876@outflux.net>
 <877hlqas9e.fsf@basil.nowhere.org>
 <20100623145437.GJ5876@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100623145437.GJ5876@outflux.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 07:54:37AM -0700, Kees Cook wrote:
> Oh, er, I actually added these configs because Eric Paris recommended them
> as handy for distributions.  I'm fine with dropping them, but will I be

Distributions should use init scripts for that imho.

> asked to add them back later?  And what about the case of CONFIG_SYSCTL
> being unset?

"depends on SYSCTL"

> 
> > However the help texts are useful,  these should be in the sysctl
> > documentatin in Documentation instead.
> 
> I documented the sysctls in Documentation/Yama.txt (where SELinux.txt and
> Smack.txt live) should I create an additional file in Documentation/sysctl/
> with that information (moved from Yama.txt) or move Yama.txt there?

Ok missed that. what you prefer.

> I actually think this is a flaw in get_task_comm.  (Though actually it's
> the fault of terminals if they process dangerous escape sequences. Worst
> case tends to just be confusing output, but that's not important --
> nothing should spew non-printables regardless.)  Would a patch to
> get_task_comm be accepted to replace non-printables with "?" or something
> when filling the buffer?

Probably makes sense, although you might annoy someone who wants Kanji
process names in UTF-8 or similar.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
