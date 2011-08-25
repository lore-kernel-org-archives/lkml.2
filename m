Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751086Ab1HYOEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 10:04:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33086 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab1HYOEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 10:04:40 -0400
Date: Thu, 25 Aug 2011 16:04:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Andi Kleen <andi@firstfloor.org>, Zan Lynx <zlynx@acm.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Nathan Lynch <ntl@pobox.com>,
        Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        "containers@lists.osdl.org" <containers@lists.osdl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        LINUXFS-ML <linux-fsdevel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [RFC] fs, proc: Introduce the /proc/<pid>/map_files/ directory v2
Message-ID: <20110825140434.GU25996@one.firstfloor.org>
References: <20110824085329.GL29452@sun> <4E551331.1010709@acm.org> <4E551693.5030400@parallels.com> <m2wre2d83p.fsf@firstfloor.org> <4E55EEE4.4050902@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E55EEE4.4050902@parallels.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 10:42:44AM +0400, Pavel Emelyanov wrote:
> On 08/24/2011 09:36 PM, Andi Kleen wrote:
> > Pavel Emelyanov <xemul@parallels.com> writes:
> >>
> >> No and this is the trick - when you readlink it - it give you trash, but
> >> when you open one - you get exactly the same file as the map points to.
> > 
> > Isn't that a minor security hole?
> > 
> > For example if I pass a file descriptor into a chroot process for
> > reading, and with this interface you can open it for writing too.
> > I could see this causing problems.
> 
> How does it differ from the /proc/pid/fd links?

Those cannot be opened I thought.
-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
