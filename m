Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589Ab1H2NEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 09:04:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:33866 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab1H2NE3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 09:04:29 -0400
Subject: Re: [PATCH] perf_event: fix broken calc_timer_values()
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, emunson@mgebm.net,
        vweaver1@eecs.utk.edu
Date: Mon, 29 Aug 2011 15:04:21 +0200
In-Reply-To: <20110829124112.GA4828@quad>
References: <20110829124112.GA4828@quad>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314623061.2816.23.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-29 at 14:41 +0200, Stephane Eranian wrote:
> The bug was not present in kernel up to 3.0. It turns
> out the bug was introduced by the following commit:
> 
> commit c4794295917ebeda8013b6cb9c8d71ab4f74a1fa 

Ah, up to /and including/ 3.0, since:

git describe --contains c4794295917ebeda8013b6cb9c8d71ab4f74a1fa --match "v*"
v3.1-rc1~299^2~32

So only perf/urgent is needed.
