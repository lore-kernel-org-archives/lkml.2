Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab2DAWqJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 18:46:09 -0400
Received: from ozlabs.org ([203.10.76.45]:36079 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692Ab2DAWqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 18:46:07 -0400
Date: Mon, 2 Apr 2012 08:45:25 +1000
From: Paul Mackerras <paulus@samba.org>
To: Avi Kivity <avi@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Mackerras <paulus@au1.ibm.com>, Alexander Graf <agraf@suse.de>
Subject: Re: [GIT PULL] KVM updates for the 3.4 merge window
Message-ID: <20120401224525.GA28843@bloggs.ozlabs.ibm.com>
References: <4F688F48.6090303@redhat.com>
 <1332461414.2982.90.camel@pasglop>
 <CA+55aFxdf_K97KJ-phck-2YcTWAc6icc+Qhi6hOg0MA8FAjiyA@mail.gmail.com>
 <4F6EEEC1.4030608@redhat.com>
 <20120326213809.GA29788@bloggs.ozlabs.ibm.com>
 <4F7191E8.7020804@redhat.com>
 <20120330120107.GA28503@bloggs.ozlabs.ibm.com>
 <4F784C4D.3000409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F784C4D.3000409@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2012 at 03:38:37PM +0300, Avi Kivity wrote:
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

OK.  Then there are about six commits from that string that are small,
simple fixes for bugs introduced in earlier patches, that only affect
arch/powerpc.  They should go into Linus' tree as soon as possible.

How do you want to handle those?  Do you want them as patches or as a
git tree, and if the latter, what do you prefer that I base them on?
Or should I send them in via Ben?

Paul.
