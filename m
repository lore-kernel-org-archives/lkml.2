Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab0ETSpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 14:45:55 -0400
Received: from tortuga.cyrius.com ([94.228.35.166]:38364 "EHLO
	tortuga.cyrius.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab0ETSpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 14:45:54 -0400
X-Greylist: delayed 526 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 May 2010 14:45:54 EDT
Date: Thu, 20 May 2010 19:37:01 +0100
From: Martin Michlmayr <tbm@cyrius.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       eric.dumazet@gmail.com, Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>
Subject: Re: Does anyone care about gcc 3.x support for *x86* anymore?
Message-ID: <20100520183701.GW26248@jirafa.cyrius.com>
References: <4BF33CAD.2070602@zytor.com>
 <871vd8xb8t.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871vd8xb8t.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen <andi@firstfloor.org> [2010-05-19 15:38]:
> > If there isn't a reason to preserve support, I would like to consider
> > discontinue support for using gcc 3 to compile x86 kernels.  If there is
> > a valid use case, it would be good to know what it is.
> 
> I suspect there are still distributions around that use it as a standard
> compiler. Wasn't it used in some major release of Debian?

Not in a recent one, no.
-- 
Martin Michlmayr
http://www.cyrius.com/
