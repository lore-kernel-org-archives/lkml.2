Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab0KDDNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 23:13:36 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64509 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab0KDDNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 23:13:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=U9iE3mGCYs5rAzxgjZJ02p+5qJNLPVd4qGY7Mx4opatACiN2lQDHfYC7SfDLqN2BiS
         ui9kWA8U3dMx67I0pYUh3jg+J5kjFSNnYeIP6IG38tUO8ltfJtdpKf3Bc6Bgbwf7QaYj
         zvQ2o9qzIABEGYleZ/RQXv3Ucyg9iGvJtLQFg=
From: Ben Gamari <bgamari.foss@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] Add Kconfig option for default swappiness
In-Reply-To: <alpine.DEB.2.00.1011021235130.21387@chino.kir.corp.google.com>
References: <1288668052-32036-1-git-send-email-bgamari.foss@gmail.com> <alpine.DEB.2.00.1011012030100.12298@chino.kir.corp.google.com> <87oca7evbo.fsf@gmail.com> <alpine.DEB.2.00.1011021235130.21387@chino.kir.corp.google.com>
User-Agent: Notmuch/0.3.1-158-g04cd99c (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Wed, 03 Nov 2010 23:13:31 -0400
Message-ID: <878w19bx2c.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Nov 2010 12:39:52 -0700 (PDT), David Rientjes <rientjes@google.com> wrote:
> On Tue, 2 Nov 2010, Ben Gamari wrote:
> > Packaging concerns, as I mentioned before,
> 
> That you snipped from the changelog?
> 
Guilty as charged. Sorry about that, time has been in short supply
recently.

> You could say the same thing for any sysctl, it's not indicative of why 
> this particular change is needed in the kernel.
> 
This is certainly true; a distribution could in principle want to tweak
the default values of any of the sysctl knobs. If we wanted to tweak
anything else in addition to swappiness that I wouldn't have even
bothered to submit the patch since I'll be the first to admit that the
precedent set by further growing the Kconfig phase space is not a
positive one. That being said, swappiness is one of the more significant
knobs in the vm and certainly one of the more likely to be tuned by a
distribution.

> Let's not have the "in short" answer, what's the "long" answer?

See my recent response to Wu Fengguang.

Cheers,

- Ben
