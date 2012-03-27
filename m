Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab2C0KKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 06:10:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757976Ab2C0KJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 06:09:58 -0400
Message-ID: <4F7191E8.7020804@redhat.com>
Date: Tue, 27 Mar 2012 12:09:44 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Mackerras <paulus@au1.ibm.com>, Alexander Graf <agraf@suse.de>
Subject: Re: [GIT PULL] KVM updates for the 3.4 merge window
References: <4F688F48.6090303@redhat.com> <1332461414.2982.90.camel@pasglop> <CA+55aFxdf_K97KJ-phck-2YcTWAc6icc+Qhi6hOg0MA8FAjiyA@mail.gmail.com> <4F6EEEC1.4030608@redhat.com> <20120326213809.GA29788@bloggs.ozlabs.ibm.com>
In-Reply-To: <20120326213809.GA29788@bloggs.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2012 11:38 PM, Paul Mackerras wrote:
> On Sun, Mar 25, 2012 at 12:09:05PM +0200, Avi Kivity wrote:
>
> > I can switch to fast-forward-only in the future, but I'm afraid that
> > this particular tree is broken for good.  The un-rebased
> > fast-forward-only source for this is kvm.git master, which I don't think
> > you want to pull.  It will cause every kvm commit to appear twice and
> > confuse everyone.
>
> There are patches from me in there that have been pending since
> December last year, and now look like they won't be going upstream
> until June.  So, under the circumstances, how would you (Avi) feel
> about Ben and I committing the KVM patches that only affect powerpc to
> Ben's tree and sending them to Linus that way before the merge window
> closes?

That's fine if there are no interdependencies.  It looks like 74df956
will be a problem though.

The other two options are:

- I'll add my signoff to the commits that lack it.  This unbreaks the
committer lacks signoff.
- I remove Alex's commits, Alex sends me a pull request based on that
tree, I pull it in.  Alex being away for three weeks is a minor flaw in
this plan.
- As above, but with you sending me that tree as temporary kvm-ppc
maintainer.

Options 2/3 are harder as there are a few interdependencies.

Linus, if the first option is acceptable, a tree is available at the
same place:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/3.4

otherwise, please provide guidance.

-- 
error compiling committee.c: too many arguments to function

