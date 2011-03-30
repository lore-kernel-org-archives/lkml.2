Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933582Ab1C3WVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:21:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:48502 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933138Ab1C3WVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:21:05 -0400
Date: Thu, 31 Mar 2011 00:21:02 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Avi Kivity <avi@redhat.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]arch:x86:kvm:i8254.h Fix typo in kvm_pit
In-Reply-To: <4D93659F.2020900@redhat.com>
Message-ID: <alpine.LNX.2.00.1103310019540.26754@pobox.suse.cz>
References: <1301501942-3937-1-git-send-email-justinmattock@gmail.com> <4D9359CC.6050508@redhat.com> <4D935AC3.2030509@gmail.com> <4D93659F.2020900@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011, Avi Kivity wrote:

> > > > The below patch changes base_addresss to base_address.
> > > > Note: I have grepped for base_addresss and nothing shows up,
> > > > grepping for base_address gets me lots of output, telling me that
> > > > this is a typo, but could be wrong.
> > > > 
> > > > Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
> > > > 
> > > > ---
> > > > arch/x86/kvm/i8254.h | 2 +-
> > > > 1 files changed, 1 insertions(+), 1 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/i8254.h b/arch/x86/kvm/i8254.h
> > > > index 46d08ca..c2fa48b 100644
> > > > --- a/arch/x86/kvm/i8254.h
> > > > +++ b/arch/x86/kvm/i8254.h
> > > > @@ -33,7 +33,7 @@ struct kvm_kpit_state {
> > > > };
> > > > 
> > > > struct kvm_pit {
> > > > - unsigned long base_addresss;
> > > > + unsigned long base_address;
> > > > struct kvm_io_device dev;
> > > > struct kvm_io_device speaker_dev;
> > > > struct kvm *kvm;
> > > 
> > > Why not remove the variable completely?
> > > 
> > 
> > didnt even think to completely remove the variable(figured it was used
> > somewhere).I will look at that and resend with removal of the variable for
> > you..
> 
> Well if it was used, you ought to have changed all of the users, no?

I am afraid Justin is not trying to compile-test his patches (I got this 
suspicion after last patchset trying to remove all the includes of 
version.h).

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
