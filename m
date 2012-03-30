Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934451Ab2C3MDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:03:01 -0400
Received: from ozlabs.org ([203.10.76.45]:53289 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933770Ab2C3MCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:02:06 -0400
Date: Fri, 30 Mar 2012 23:01:07 +1100
From: Paul Mackerras <paulus@samba.org>
To: Avi Kivity <avi@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Mackerras <paulus@au1.ibm.com>, Alexander Graf <agraf@suse.de>
Subject: Re: [GIT PULL] KVM updates for the 3.4 merge window
Message-ID: <20120330120107.GA28503@bloggs.ozlabs.ibm.com>
References: <4F688F48.6090303@redhat.com>
 <1332461414.2982.90.camel@pasglop>
 <CA+55aFxdf_K97KJ-phck-2YcTWAc6icc+Qhi6hOg0MA8FAjiyA@mail.gmail.com>
 <4F6EEEC1.4030608@redhat.com>
 <20120326213809.GA29788@bloggs.ozlabs.ibm.com>
 <4F7191E8.7020804@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7191E8.7020804@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 12:09:44PM +0200, Avi Kivity wrote:

> > There are patches from me in there that have been pending since
> > December last year, and now look like they won't be going upstream
> > until June.  So, under the circumstances, how would you (Avi) feel
> > about Ben and I committing the KVM patches that only affect powerpc to
> > Ben's tree and sending them to Linus that way before the merge window
> > closes?
> 
> That's fine if there are no interdependencies.  It looks like 74df956
> will be a problem though.
> 
> The other two options are:
> 
> - I'll add my signoff to the commits that lack it.  This unbreaks the
> committer lacks signoff.

I just noticed that the branch you asked Linus to pull includes none
of the patches that Alex sent you in the last batch, in the email with
subject "[PULL 00/56] ppc patch queue 2012-03-15" sent on March 15,
where he asked you to pull git://github.com/agraf/linux-2.6.git
for-upstream.

What happened?  Did they get lost in the re-signing, or is there some
reason you thought they shouldn't go in?

Thanks,
Paul.
