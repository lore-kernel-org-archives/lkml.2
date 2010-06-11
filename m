Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab0FKHev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 03:34:51 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:40184 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752868Ab0FKHeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 03:34:50 -0400
X-Greylist: delayed 524 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jun 2010 03:34:49 EDT
From: Reinhard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>
To: Joe Perches <joe@perches.com>
Cc: Christoph Egger <siccegge@cs.fau.de>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 0/5] Removing dead code
Organization: Uni Erlangen, Informatik 4, Lehrstuhl =?utf-8?Q?f=C3=BCr?=
 Betriebs- und verteile Systeme
References: <cover.1275925219.git.siccegge@cs.fau.de>
	<1276195612.1556.279.camel@Joe-Laptop.home>
X-Url: http://www4.informatik.uni-erlangen.de/~tartler
Date: Fri, 11 Jun 2010 09:26:02 +0200
In-Reply-To: <1276195612.1556.279.camel@Joe-Laptop.home> (Joe Perches's
	message of "Thu, 10 Jun 2010 11:46:52 -0700")
Message-ID: <rwutypado8l.fsf@faui48a.informatik.uni-erlangen.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> (cc's trimmed and rpjday added)
>
> On Wed, 2010-06-09 at 11:58 +0200, Christoph Egger wrote:
>> I've been running a check on the arch/powerpc sourcetree for
>> config Items not defined in Kconfig and found5 such chases.
>
> Are you aware of
> http://www.crashcourse.ca/wiki/index.php/Kernel_cleanup_scripts

Yes, we are. These scripts aim at a very similar goal.  However, we are
using a more sound approach that actually involves parsing CPP
statements and the kconfig language and checking the resulting
constraints with SAT solving tools.  This way, we get way more precise
results.

You can read about our approach in [1].

[1] http://portal.acm.org/citation.cfm?id=1629732

-- 
Reinhard Tartler                     Department of Computer Science IV
Martensstr 1, 91058 Erlangen Germany, University of Erlangen-Nuremberg
            http://www4.informatik.uni-erlangen.de/~tartler
