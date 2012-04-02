Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab2DBJHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 05:07:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597Ab2DBJHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 05:07:14 -0400
Message-ID: <4F796C38.1000908@redhat.com>
Date: Mon, 02 Apr 2012 12:07:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Mackerras <paulus@au1.ibm.com>, Alexander Graf <agraf@suse.de>
Subject: Re: [GIT PULL] KVM updates for the 3.4 merge window
References: <4F688F48.6090303@redhat.com> <1332461414.2982.90.camel@pasglop> <CA+55aFxdf_K97KJ-phck-2YcTWAc6icc+Qhi6hOg0MA8FAjiyA@mail.gmail.com> <4F6EEEC1.4030608@redhat.com> <20120326213809.GA29788@bloggs.ozlabs.ibm.com> <4F7191E8.7020804@redhat.com> <20120330120107.GA28503@bloggs.ozlabs.ibm.com> <4F784C4D.3000409@redhat.com> <20120401224525.GA28843@bloggs.ozlabs.ibm.com>
In-Reply-To: <20120401224525.GA28843@bloggs.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2012 01:45 AM, Paul Mackerras wrote:
> On Sun, Apr 01, 2012 at 03:38:37PM +0300, Avi Kivity wrote:
> > On 03/30/2012 03:01 PM, Paul Mackerras wrote:
> > > I just noticed that the branch you asked Linus to pull includes none
> > > of the patches that Alex sent you in the last batch, in the email with
> > > subject "[PULL 00/56] ppc patch queue 2012-03-15" sent on March 15,
> > > where he asked you to pull git://github.com/agraf/linux-2.6.git
> > > for-upstream.
> > >
> > > What happened?  Did they get lost in the re-signing, or is there some
> > > reason you thought they shouldn't go in?
> > 
> > That pull request was send three days before the merge window opened;
> > patches are supposed to cook for a while in -next before being merged,
> > especially large trees like that one.
>
> OK.  Then there are about six commits from that string that are small,
> simple fixes for bugs introduced in earlier patches, that only affect
> arch/powerpc.  They should go into Linus' tree as soon as possible.

Sure.

> How do you want to handle those?  Do you want them as patches or as a
> git tree, and if the latter, what do you prefer that I base them on?
> Or should I send them in via Ben?

Git tree against upstream please.

-- 
error compiling committee.c: too many arguments to function

