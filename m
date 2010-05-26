Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934155Ab0EZIrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 04:47:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:37145 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933954Ab0EZIrk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 04:47:40 -0400
Subject: Re: [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kevin Hilman <khilman@deeprootsystems.com>, felipe.balbi@nokia.com,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>
In-Reply-To: <201005250138.16293.rjw@sisk.pl>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	 <201005242049.18920.rjw@sisk.pl> <87wrusvrqe.fsf@deeprootsystems.com>
	 <201005250138.16293.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 May 2010 10:47:35 +0200
Message-ID: <1274863655.5882.4875.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 01:38 +0200, Rafael J. Wysocki wrote:
> > This of course will lead to a scattering of suspend blockers into any
> > drivers/subsystems considered "useful", which by looking through current
> > Android kernels is many of them.
> 
> That depends on the maintainers of these subsystems, who still have the power
> to reject requested changes. 

So as a scheduler maintainer I'm going to merge a patch that does a
suspend_blocker when the runqueue's aren't empty... how about that?
