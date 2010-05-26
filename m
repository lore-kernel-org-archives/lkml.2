Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050Ab0EZKIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 06:08:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51802 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab0EZKIL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 06:08:11 -0400
Subject: Re: [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Florian Mickler <florian@mickler.org>
Cc: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>, felipe.balbi@nokia.com,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>
In-Reply-To: <20100526120242.5c9b73ad@schatten.dmk.lab>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	 <201005242049.18920.rjw@sisk.pl> <87wrusvrqe.fsf@deeprootsystems.com>
	 <201005250138.16293.rjw@sisk.pl> <1274863655.5882.4875.camel@twins>
	 <AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com>
	 <1274867106.5882.5090.camel@twins>
	 <20100526120242.5c9b73ad@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 May 2010 12:08:04 +0200
Message-ID: <1274868484.5882.5176.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-26 at 12:02 +0200, Florian Mickler wrote:
> The summary is: The device this kernel is running on dosn't want to
> (or can) rely on userspace to save power. This is because it is an open
> system, without an app-store or the like. Everyone can run what he
> wants.
> 
> So anything relying on (all) userspace solves a different problem.

So what stops an application from grabbing a suspend blocker?
