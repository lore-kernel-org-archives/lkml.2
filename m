Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab1CBTq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 14:46:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980Ab1CBTqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 14:46:25 -0500
Date: Wed, 2 Mar 2011 14:46:11 -0500
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Huang, Ying" <ying.huang@intel.com>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip 2/2 resend] x86, traps: Drop nmi_reason_lock until
 it is really needed
Message-ID: <20110302194611.GZ11359@redhat.com>
References: <4D6E631B.6040701@openvz.org>
 <20110302154645.GA11827@elte.hu>
 <4D6E6886.2060707@openvz.org>
 <20110302160315.GA12620@elte.hu>
 <4D6E6CB6.7000700@openvz.org>
 <20110302184053.GW11359@redhat.com>
 <4D6E9700.50501@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6E9700.50501@openvz.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 10:14:08PM +0300, Cyrill Gorcunov wrote:
> > 
> > Now this spinlock doesn't affect them, because they registered an nmi
> > handler to catch it and dump their stack (I modified the code to use
> > DIE_NMIUNKNOWN instead of DIE_NMI to avoid conflict with the
> > nmi_watchdog).  But I don't know what the affect is, if that spinlock is
> > not there (I sent a private email to SGI inquiring, their guy wasn't
> > around this week).
> 
>   Don, do you know -- was new nmi-watchdog system tested with UV machine
> somewhere?

They are testing it now, I am working through the issues with them.

Cheers,
Don
