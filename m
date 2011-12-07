Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab1LGPQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 10:16:16 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55276 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586Ab1LGPQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 10:16:14 -0500
Message-ID: <1323270953.4009.21.camel@lappy>
Subject: Re: [PATCH 1/2] KVM: VMX: Notify if VMX is already in use
From: Sasha Levin <levinsasha928@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Date: Wed, 07 Dec 2011 17:15:53 +0200
In-Reply-To: <4EDF7797.9080103@redhat.com>
References: <1322764218-4698-1-git-send-email-levinsasha928@gmail.com>
	   <4EDF7590.5060701@redhat.com> <1323267521.4009.11.camel@lappy>
	  <4EDF76D6.7020800@redhat.com> <1323267891.4009.16.camel@lappy>
	 <4EDF7797.9080103@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-07 at 16:26 +0200, Avi Kivity wrote:
> On 12/07/2011 04:24 PM, Sasha Levin wrote:
> > > 
> > > That's odd.  IIRC when we discussed this with them, they were executing
> > > VMXON/VMXOFF dynamically.  Looks like they changed this.
> > > 
> > > Anyway, please adjust according to Joerg's comment (and add the word
> > > "using"), and I'll apply.
> >
> > I've seen it the day before I've sent those patches. vbox driver loaded,
> > kvm silently failed and rdmsr showed SVME turned on.
> >
> > Will resend.
> 
> Ah, maybe they do it differently on AMD.  Or they changed things.

I've grabbed their code just to see whats going on there and traced the
vmxon calls back to module init.

Are you sure it ever happened on-demand and not on init? If you are,
I'll actually build that module and give it a go :)

-- 

Sasha.

