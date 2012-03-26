Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab2CZVis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 17:38:48 -0400
Received: from ozlabs.org ([203.10.76.45]:49986 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757057Ab2CZVir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 17:38:47 -0400
Date: Tue, 27 Mar 2012 08:38:09 +1100
From: Paul Mackerras <paulus@samba.org>
To: Avi Kivity <avi@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Mackerras <paulus@au1.ibm.com>, Alexander Graf <agraf@suse.de>
Subject: Re: [GIT PULL] KVM updates for the 3.4 merge window
Message-ID: <20120326213809.GA29788@bloggs.ozlabs.ibm.com>
References: <4F688F48.6090303@redhat.com>
 <1332461414.2982.90.camel@pasglop>
 <CA+55aFxdf_K97KJ-phck-2YcTWAc6icc+Qhi6hOg0MA8FAjiyA@mail.gmail.com>
 <4F6EEEC1.4030608@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6EEEC1.4030608@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2012 at 12:09:05PM +0200, Avi Kivity wrote:

> I can switch to fast-forward-only in the future, but I'm afraid that
> this particular tree is broken for good.  The un-rebased
> fast-forward-only source for this is kvm.git master, which I don't think
> you want to pull.  It will cause every kvm commit to appear twice and
> confuse everyone.

There are patches from me in there that have been pending since
December last year, and now look like they won't be going upstream
until June.  So, under the circumstances, how would you (Avi) feel
about Ben and I committing the KVM patches that only affect powerpc to
Ben's tree and sending them to Linus that way before the merge window
closes?

Paul.
