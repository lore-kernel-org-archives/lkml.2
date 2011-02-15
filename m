Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab1BOLxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 06:53:43 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36632 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab1BOLxl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 06:53:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DFk4Ln9dF9ele1mfuifDi3a3ZIp1PHQiw9I0p6ujZgKPi0uLlm5/kyOcwYHZNlt17H
         Q4tOHi6oeEqRT/8riqk4oYjJHPf5B7aSpCyF0SFyHEsbNCXF6TX0E0hPvM6SPd9t0+jr
         KMjKen5ptoyu4jWRGl5zo43W/uKrbtLQRqtvQ=
MIME-Version: 1.0
In-Reply-To: <20110214230902.GM2256@linux.vnet.ibm.com>
References: <1297707868.5226.189.camel@laptop>
	<1297718964.23343.75.camel@gandalf.stny.rr.com>
	<1297719576.23343.80.camel@gandalf.stny.rr.com>
	<20110214.134600.179933733.davem@davemloft.net>
	<20110214223755.436e7cf4@mfleming-mobl1.ger.corp.intel.com>
	<BLU0-SMTP166A8555C791786059B0FF96D00@phx.gbl>
	<20110214230902.GM2256@linux.vnet.ibm.com>
Date: Tue, 15 Feb 2011 11:53:37 +0000
Message-ID: <AANLkTikO_BCyFvcp=VZXQK-AvAFSB7sxQS_4_=HW3bZi@mail.gmail.com>
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
From: Will Newton <will.newton@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Matt Fleming <matt@console-pimps.org>,
        David Miller <davem@davemloft.net>, rostedt@goodmis.org,
        peterz@infradead.org, jbaron@redhat.com, hpa@zytor.com, mingo@elte.hu,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org,
        vapier@gentoo.org, cmetcalf@tilera.com, dhowells@redhat.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 11:09 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:

Hi Paul,

> What CPU family are we talking about here?  For cache coherent CPUs,
> cache coherence really is supposed to work, even for mixed atomic and
> non-atomic instructions to the same variable.

Is there a specific situation you can think of where this would be a
problem? I have to admit to a certain amount of unease with the design
our hardware guys came up with, but I don't have a specific case where
it won't work, just cases where it is less than optimal.
