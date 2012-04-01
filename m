Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab2DAVCp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 17:02:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:34951 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947Ab2DAVCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 17:02:44 -0400
Message-ID: <1333314138.30734.17.camel@pasglop>
Subject: Re: [GIT PULL] KVM updates for the 3.4 merge window
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Avi Kivity <avi@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Mackerras <paulus@au1.ibm.com>, Alexander Graf <agraf@suse.de>
Date: Mon, 02 Apr 2012 07:02:18 +1000
In-Reply-To: <4F784C4D.3000409@redhat.com>
References: <4F688F48.6090303@redhat.com> <1332461414.2982.90.camel@pasglop>
	 <CA+55aFxdf_K97KJ-phck-2YcTWAc6icc+Qhi6hOg0MA8FAjiyA@mail.gmail.com>
	 <4F6EEEC1.4030608@redhat.com>
	 <20120326213809.GA29788@bloggs.ozlabs.ibm.com>
	 <4F7191E8.7020804@redhat.com>
	 <20120330120107.GA28503@bloggs.ozlabs.ibm.com>
	 <4F784C4D.3000409@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-01 at 15:38 +0300, Avi Kivity wrote:
> On 03/30/2012 03:01 PM, Paul Mackerras wrote:
> > I just noticed that the branch you asked Linus to pull includes none
> > of the patches that Alex sent you in the last batch, in the email with
> > subject "[PULL 00/56] ppc patch queue 2012-03-15" sent on March 15,
> > where he asked you to pull git://github.com/agraf/linux-2.6.git
> > for-upstream.
> >
> > What happened?  Did they get lost in the re-signing, or is there some
> > reason you thought they shouldn't go in?
> 
> That pull request was send three days before the merge window opened;
> patches are supposed to cook for a while in -next before being merged,
> especially large trees like that one.

These are all powerpc specific patches that have been cooking in Alex
tree for a while and elsewhere before that. They almost only affect
arch/powerpc/kvm, and as such don't really need a lot of integration
testing in -next. A bit for sure but not necessarily monthes.

The current process is such that it takes absolutely forever for our
patches to get in, which is a major PITA for something in such state of
active development.

Why don't we have Alex tree go straight to -next like I do with Kumar
for example ? That way I don't need to have his branch sit in my tree
for weeks before I push it out to Linus.

Cheers,
Ben.


