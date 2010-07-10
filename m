Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab0GJR3t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 13:29:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64689 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab0GJR3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 13:29:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AT+LbCTXA8dVYuMVY/ZpNWWyentqmfdhhviPVnTQdWGX1xs+9rr4/M0cSRP0LsyWdC
         imqHp+CKdPM08PFuVsN0h98gzhkgbQxD30i6jnWmvamhwTXfhpze7p0guYvJ+aGy4qMg
         am1F9OV2AkXGF+MGzTFsFuCfObTkL2reuP1xs=
MIME-Version: 1.0
In-Reply-To: <1278774688.1998.42.camel@laptop>
References: <1278682707.6083.227.camel@Palantir>
	<1278685951.1900.215.camel@laptop>
	<1278748227.4390.26.camel@Palantir>
	<1278774688.1998.42.camel@laptop>
Date: Sat, 10 Jul 2010 19:29:46 +0200
Message-ID: <AANLkTinbHDFM4IrkATJ1KJhts5LFBelSmUTeS6cudM58@mail.gmail.com>
Subject: Re: periods and deadlines in SCHED_DEADLINE
From: Harald Gustafsson <hgu1972@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Raistlin <raistlin@linux.it>, linux-kernel <linux-kernel@vger.kernel.org>,
       Song Yuan <song.yuan@ericsson.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicola Manica <nicola.manica@disi.unitn.it>,
       Luca Abeni <lucabe72@email.it>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Harald Gustafsson <harald.gustafsson@ericsson.com>,
       Bjoern Brandenburg <bbb@email.unc.edu>, bastoni@cs.unc.edu,
       Giuseppe Lipari <lipari@retis.sssup.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Right, so I would actually expect RT job release to be triggered by
> external events (say interrupts) more than on their own. And when its an
> external event I don't really see the use of this new syscall.

I agree that the common usage would be to wake up by an external
event, rather than sleeping for a specified time period that is longer
than the set period. I would assume that the period would be changed
to match some generic operational unit of the task like a frame rate
or packet rate, etc.
