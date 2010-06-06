Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab0FFTPQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 15:15:16 -0400
Received: from smtp-out.google.com ([216.239.44.51]:3702 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab0FFTPO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 15:15:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=HSlV1wt+rtCHSYgjz0rtP1VVxETJA2XJ3xXFY2wxYH0M8nTMqGptwL3Wa5GHDh04N
	AHhtWiNkA+MxpGYKNLpzw==
MIME-Version: 1.0
In-Reply-To: <20100606190525.GA20517@infradead.org>
References: <1275834706.7227.545.camel@mulgrave.site>
	<alpine.LFD.2.00.1006061725000.2933@localhost.localdomain>
	<1275844114.7227.552.camel@mulgrave.site>
	<20100606190525.GA20517@infradead.org>
Date: Sun, 6 Jun 2010 12:15:10 -0700
Message-ID: <AANLkTikKx-gXCGtNo3woHLCpBoEQ7hG9Jbiq3hwUTW_w@mail.gmail.com>
Subject: Re: [linux-pm] suspend blockers & Android integration
From: Brian Swetland <swetland@google.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>, "Arve Hj?nnev?g" <arve@android.com>,
       Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
       Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Felipe Balbi <felipe.balbi@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 6, 2010 at 12:05 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Sun, Jun 06, 2010 at 12:08:34PM -0500, James Bottomley wrote:
>> Well, we sort of tried this when Greg pulled some of them into the
>> staging tree.  The problem is that without the annotations, the drivers
>> are still different, and patches won't apply, so, unsurprisingly, they
>> didn't get improved or even maintained.
>
> Err, the biggest pile in staging was meta drivers like the binder or
> some oom killer magic which are flat out braindead and wrong and have
> no chance going into mainline anyway.  That's something different from
> real hardware drivers, although a few of those made it into staging as
> well if I remember correctly.

I was shocked when Greg pulled the binder driver and some of the other
"generic" android drivers into staging, because it was always my
assumption that nobody upstream would want them.  We did get some
bugfixes for the binder driver (thanks!) but the general reaction was
pretty much the same as yours here.  I then was relatively unsurprised
when it was dropped (we find it useful, upstream finds it useless, not
much else to say).

The various SoC peripheral drivers are, I suspect, much less
contentious (modulo suspend blocker usage and any necessary kernel
style cleanup).

Brian
