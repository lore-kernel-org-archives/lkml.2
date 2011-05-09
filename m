Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab1EIMQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 08:16:41 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:50465 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab1EIMQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 08:16:39 -0400
Date: Mon, 9 May 2011 05:16:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
        mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] rcu: provide rcu_virt_note_context_switch()
 function.
Message-ID: <20110509121630.GJ2608@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1304515864-17105-1-git-send-email-gleb@redhat.com>
 <1304515864-17105-2-git-send-email-gleb@redhat.com>
 <20110504163542.GA2641@linux.vnet.ibm.com>
 <4DC7AB16.7010609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC7AB16.7010609@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 11:51:34AM +0300, Avi Kivity wrote:
> On 05/04/2011 07:35 PM, Paul E. McKenney wrote:
> >On Wed, May 04, 2011 at 04:31:03PM +0300, Gleb Natapov wrote:
> >>  Provide rcu_virt_note_context_switch() for vitalization use to note
> >>  quiescent state during guest entry.
> >
> >Very good, queued on -rcu.
> >
> >Unless you tell me otherwise, I will assume that you want to carry the
> >patch modifying KVM to use this.
> 
> Is -rcu a fast-forward-only tree (like tip)?  If so I'll merge it
> and apply patch 2.

Yep, -rcu is subject to rebase and feeds into -tip.  The patch is
SHA 29ce831000081dd757d3116bf774aafffc4b6b20 in

	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git

Branch is rcu/next.  My guess is that this commit will show up in
-tip soon.

							Thanx, Paul
