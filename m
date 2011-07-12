Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630Ab1GLHeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 03:34:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57040 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab1GLHeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 03:34:15 -0400
Date: Tue, 12 Jul 2011 08:34:01 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: =?utf-8?B?5p6X5a6P5paH?= <tommy.lin.1101@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] arch: arm: Correct the dependency of HAVE_ARM_TWD
Message-ID: <20110712073401.GB23270@n2100.arm.linux.org.uk>
References: <1310104763-12948-1-git-send-email-tommy.lin@caviumnetworks.com> <20110708091014.GA15142@oksana.dev.rtsoft.ru> <20110708091713.GF2414@n2100.arm.linux.org.uk> <CAB8eogcYUSYPBS9UAv29MqnTLdUrbYt+y=yLmzG0r92kz-PUXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAB8eogcYUSYPBS9UAv29MqnTLdUrbYt+y=yLmzG0r92kz-PUXA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 02:57:38PM +0800, 林宏文 wrote:
> 2011/7/8 Russell King - ARM Linux <linux@arm.linux.org.uk>
> >
> > On Fri, Jul 08, 2011 at 01:10:14PM +0400, Anton Vorontsov wrote:
> > > On Fri, Jul 08, 2011 at 01:59:23PM +0800, Tommy Lin wrote:
> > > Russell,
> > >
> > > As the patch is needed for CNS3xxx Watchdog support, I'd like to take
> > > it via CNS3xxx tree, if you're OK with that.
> >
> > No.
> >
> > TWD is only useful if SMP is enabled, otherwise the contained code
> > won't be called.  Without SMP you'll find that the timer rate will
> > be zero.
> >
> > So actually your problems are bigger than just this dependency.
>
> I think LOCAL_TIMERS is the one that useful if SMP is enabled. The zero
> timer rate issue still able to limited by LOCAL_TIMERS.

No.  I could repeat everything I've said about the initialization but
there's no point.  I'm not dropping the SMP dependency of SMP_TWD.
