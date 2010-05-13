Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885Ab0EMUHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:07:09 -0400
Received: from smtp-out.google.com ([74.125.121.35]:9213 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514Ab0EMUHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:07:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=A7ATDGAF3beArf/PCMtHWoRs4YPpgvIQe/EDz+Wr4ts7PYSUvOY/mE/tGgox1VnlA
	hPzmGxOHm8Rm5RuRNksmg==
MIME-Version: 1.0
In-Reply-To: <20100513140354.GA12639@tango.0pointer.de>
References: <eJjRf-6YM-1@gated-at.bofh.it> <eJktY-7JG-7@gated-at.bofh.it>
	 <eJktY-7JG-5@gated-at.bofh.it> <4BEAB6FC.8090105@intcomgrp.com>
	 <AANLkTinwfvtALZhefqp_KbaUqH0EQFiokqvCQdMZC5M7@mail.gmail.com>
	 <1273674048.1626.117.camel@laptop>
	 <20100512190757.GA421@tango.0pointer.de>
	 <1273755719.5605.3537.camel@twins>
	 <20100513140354.GA12639@tango.0pointer.de>
Date: Thu, 13 May 2010 13:06:53 -0700
Message-ID: <s2s6599ad831005131306pa7db4c4dyd7712de7fda73cfd@mail.gmail.com>
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
From: Paul Menage <menage@google.com>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       James Kosin <jkosin@intcomgrp.com>, linux-kernel@vger.kernel.org,
       balbir@linux.vnet.ibm.com, jsafrane@redhat.com, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 7:03 AM, Lennart Poettering
<mzxreary@0pointer.de> wrote:
> By default systemd will create its groups in the "debug" hierarchy, (at
> least for now, in the long run i'd like to see "noop" hierarchy or so,
> that doesn't sound so temporary), since that controller is not useful

If you just want to track processes, mount a (named) hierarchy with no
attached subsystems.

Paul
