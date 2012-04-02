Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab2DBJqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 05:46:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:45858 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082Ab2DBJqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 05:46:48 -0400
Message-ID: <1333359979.30734.48.camel@pasglop>
Subject: Re: [GIT PULL] KVM updates for the 3.4 merge window
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Avi Kivity <avi@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Mackerras <paulus@au1.ibm.com>, Alexander Graf <agraf@suse.de>
Date: Mon, 02 Apr 2012 19:46:19 +1000
In-Reply-To: <4F796C18.2040209@redhat.com>
References: <4F688F48.6090303@redhat.com> <1332461414.2982.90.camel@pasglop>
	 <CA+55aFxdf_K97KJ-phck-2YcTWAc6icc+Qhi6hOg0MA8FAjiyA@mail.gmail.com>
	 <4F6EEEC1.4030608@redhat.com>
	 <20120326213809.GA29788@bloggs.ozlabs.ibm.com>
	 <4F7191E8.7020804@redhat.com>
	 <20120330120107.GA28503@bloggs.ozlabs.ibm.com>
	 <4F784C4D.3000409@redhat.com> <1333314138.30734.17.camel@pasglop>
	 <4F796C18.2040209@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-02 at 12:06 +0300, Avi Kivity wrote:
> > The current process is such that it takes absolutely forever for our
> > patches to get in, which is a major PITA for something in such state of
> > active development.
> 
> If the patches were posted two weeks earlier, they would have gone in.

I believe on our side they were, but Alex took a while to make up his
tree ... oh well..

> > Why don't we have Alex tree go straight to -next like I do with Kumar
> > for example ? That way I don't need to have his branch sit in my tree
> > for weeks before I push it out to Linus.
> 
> There isn't a lot of common kvm code, but what there is needs to be
> synchronized.

At least we should be able to get the important bug fixes in now, I see
that you agree in your reply to Paulus so that's good :-)

Cheers,
Ben.


