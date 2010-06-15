Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab0FOG4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 02:56:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46140 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab0FOG4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 02:56:32 -0400
Date: Tue, 15 Jun 2010 08:56:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Doug Thompson <norsk5@yahoo.com>
Cc: Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Nils Carlson <nils.carlson@ludd.ltu.se>, Ingo Molnar <mingo@elte.hu>,
       Borislav Petkov <bp@amd64.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       BrentYoung <brent.young@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Doug Thompson <dougthompson@xmission.com>,
       Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: Hardware Error Kernel Mini-Summit
Message-ID: <20100615065630.GC6727@basil.fritz.box>
References: <AANLkTil_mDFOsDUjvnp_NFZvkj0Ij-qww6BqewJ4lpHP@mail.gmail.com> <35525.41387.qm@web50105.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35525.41387.qm@web50105.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 04:46:40PM -0700, Doug Thompson wrote:

Hi Doug,

> 
> Maybe I didn't see it covered (or I missed it), but EDAC is used on more than just x86 based machines, though they are the majority by volume. We should have an abstraction that covers all the archs, like we do with other subsystems of Linux.

The way I envision it to working is that a abstracted dimm interface
(or edac2 or whatever you want to call it) can be fed from any reasonable
DIMM layout driver. This could be either DMI on x86 or some other
driver. There would be nothing really x86 specific about that.

That said I think overall the focus for memory error handling
should focus on smart event handling, not dumb accounting.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
