Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817Ab1KGQW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:22:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932651Ab1KGQW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:22:28 -0500
Date: Mon, 7 Nov 2011 18:22:07 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@ghostprotocols.net
Subject: Re: [PATCHv2 6/9] perf: expose perf capability to other modules.
Message-ID: <20111107162207.GK8670@redhat.com>
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>
 <1320323618-10375-7-git-send-email-gleb@redhat.com>
 <1320674870.18053.37.camel@twins>
 <20111107155336.GI8670@redhat.com>
 <1320681671.17809.5.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320681671.17809.5.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 05:01:11PM +0100, Peter Zijlstra wrote:
> On Mon, 2011-11-07 at 17:53 +0200, Gleb Natapov wrote:
> > I removed branch-miss-retired here because for perf user it exists. Perf
> > approximates it by other event but perf user shouldn't know that. A
> > guest is not always runs with exactly same cpu model number as a host,
> > so if we will not drop the bit here if guest will see cpu model other
> > than the one that has this quirk it will not be able to use the event.
> 
> Right, so what model number do you expose? Anyway I don't really mind
Depends on what management wants. You can specify -cpu Nehalem or -cpu
Conroe or even override model manually by doing -cpu host,model=15.

> masking the thing as long as we grow an ebx iteration,
> 
> > BTW why perf does not check event mask to see if architectural event is
> > available before programming it? 
> 
> No idea why not.. just one of those things nobody noticed/got around to
> doing or so.

--
			Gleb.
