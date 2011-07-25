Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab1GYLgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 07:36:06 -0400
Received: from dspnet.fr ([188.165.44.67]:44840 "EHLO dspnet.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab1GYLf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 07:35:59 -0400
Date: Mon, 25 Jul 2011 13:26:05 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Alexander Graf <agraf@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        Jan Kiszka <jan.kiszka@web.de>, torvalds@linux-foundation.org,
        avi@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gorcunov@gmail.com,
        levinsasha928@gmail.com, asias.hejun@gmail.com,
        prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Message-ID: <20110725112605.GA2012@dspnet.fr>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
 <4E2CA6DE.4040900@web.de>
 <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>
 <20110725075305.GA32294@elte.hu>
 <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>
 <20110725085426.GA28787@elte.hu>
 <C80CB058-38B3-4EA4-996F-4585F521415C@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C80CB058-38B3-4EA4-996F-4585F521415C@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 11:03:32AM +0200, Alexander Graf wrote:
> It's very hard to understand. It's similar to religion - I could
> easily apply your point to every reasonably low-level user space
> project out there. X for example. X needs to interact with KMS and
> DRI and whatdoiknow. So it'd be a perfect fit to pull into tools/,
> no?

The current development methodology of X11/mesa/v*api is catastrophic,
as the state of the linux graphics attest.  Having a functional
equivalent in tools would be an immense step forward, if simply by
having all the damn related code in the same place, but also because
of the interactions you cite.

  OG.

