Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab1GNMvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 08:51:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58870 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab1GNMvV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 08:51:21 -0400
Subject: Re: [PATCH 1/6] sched: Fix (harmless) typo 'CONFG_FAIR_GROUP_SCHED'
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Jan H." =?ISO-8859-1?Q?Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        trivial@kernel.org
In-Reply-To: <20110714095324.787f3ff1@lxorguk.ukuu.org.uk>
References: <1310580816-10861-1-git-send-email-schnhrr@cs.tu-berlin.de>
	 <1310580816-10861-2-git-send-email-schnhrr@cs.tu-berlin.de>
	 <1310590281.2586.34.camel@twins>
	 <20110714095324.787f3ff1@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 14 Jul 2011 14:50:53 +0200
Message-ID: <1310647853.2586.243.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-14 at 09:53 +0100, Alan Cox wrote:
> On Wed, 13 Jul 2011 22:51:21 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Wed, 2011-07-13 at 20:13 +0200, Jan H. Schönherr wrote:
> > > From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
> > 
> > WTF am I to do with crap like that?! 
> 
> Fix your mail client ? It should be recognizing the UTF8 indicators, and
> git itself is utf-8 clean.

So now we should all write complete email parsers? I thought the idea
was to use simple plain ASCII emails to that we could use scripts.

We might as well start accepting patches in attachments and force
everybody to do the MIME crap.

feh.
