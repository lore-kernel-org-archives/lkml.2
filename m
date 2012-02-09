Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab2BIHn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 02:43:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60807 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263Ab2BIHn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 02:43:56 -0500
Date: Thu, 9 Feb 2012 08:43:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: update documentation
Message-ID: <20120209074335.GA18387@elte.hu>
References: <4F323B21.7080003@oss.ntt.co.jp>
 <20120208184337.GU5650@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120208184337.GU5650@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> On Wed, Feb 08, 2012 at 06:06:41PM +0900, Fernando Luis Vázquez Cao wrote:
> > The soft and hard lockup detectors are now built on top of the hrtimer
> > and perf subsystems. Update the documentation accordingly.
> 
> > Subject: [PATCH] watchdog: update documentation
> > 
> > From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> > 
> > The soft and hard lockup detectors are now built on top of the hrtimer
> > and perf subsystems. Update the documentation accordingly.
> 
> I am fine with this (just need to address Randy's little 
> fixup).
> 
> Ingo, should I take this in and repost for you or just ack it 
> and let someone like Andrew take this in?

Yeah, would be nice to have it with Randy's ack and your 
signoff, can apply it then.

Thanks,

	Ingo
