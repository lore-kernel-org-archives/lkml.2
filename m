Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750782Ab2C1EDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 00:03:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:57071 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab2C1EDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 00:03:20 -0400
Message-ID: <1332907359.2882.77.camel@pasglop>
Subject: Re: [GIT PULL] KVM updates for the 3.4 merge window
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Avi Kivity <avi@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Mackerras <paulus@au1.ibm.com>, Alexander Graf <agraf@suse.de>
Date: Wed, 28 Mar 2012 15:02:39 +1100
In-Reply-To: <4F7191E8.7020804@redhat.com>
References: <4F688F48.6090303@redhat.com> <1332461414.2982.90.camel@pasglop>
	 <CA+55aFxdf_K97KJ-phck-2YcTWAc6icc+Qhi6hOg0MA8FAjiyA@mail.gmail.com>
	 <4F6EEEC1.4030608@redhat.com>
	 <20120326213809.GA29788@bloggs.ozlabs.ibm.com>
	 <4F7191E8.7020804@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-27 at 12:09 +0200, Avi Kivity wrote:

> That's fine if there are no interdependencies.  It looks like 74df956
> will be a problem though.
> 
> The other two options are:
> 
> - I'll add my signoff to the commits that lack it.  This unbreaks the
> committer lacks signoff.
> - I remove Alex's commits, Alex sends me a pull request based on that
> tree, I pull it in.  Alex being away for three weeks is a minor flaw in
> this plan.
> - As above, but with you sending me that tree as temporary kvm-ppc
> maintainer.
> 
> Options 2/3 are harder as there are a few interdependencies.
> 
> Linus, if the first option is acceptable, a tree is available at the
> same place:
> 
>   git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/3.4
> 
> otherwise, please provide guidance.

Linus, what's your feeling here ? I'd really like to have the bulk of
the powerpc updates this time around, they already missed the previous
merge window due to maintainers taking too long to deal with their
inbox :-) 

KVM ppc is a big WIP with little if any users at this point so the risk
of breaking things is near to non-existent, it all boils down to making
our own life easier by having stuff not drifting out of tree (and making
it possible for distros to pick it up when they decide to do so).

Cheers,
Ben.


