Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab0DVIac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 04:30:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:35543 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab0DVIaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 04:30:30 -0400
Subject: Re: [PATCH 0/3] [idled]: Idle Cycle Injector for power capping
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Chan <mike@android.com>
Cc: Salman <sqazi@google.com>, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, svaidy@linux.vnet.ibm.com,
       linux-pm@lists.linux-foundation.org, arjan@infradead.org,
       csadler@google.com, ranjitm@google.com, kenchen@google.com,
       dawnchen@google.com
In-Reply-To: <v2v8bb80c381004211832o88258fdez8e640ad9a45d11c0@mail.gmail.com>
References: <20100413234902.29004.41655.stgit@bumblebee1.mtv.corp.google.com>
	 <1271317886.32749.69.camel@laptop>
	 <v2v8bb80c381004211832o88258fdez8e640ad9a45d11c0@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Apr 2010 10:21:53 +0200
Message-ID: <1271924513.1776.315.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-21 at 18:32 -0700, Mike Chan wrote:
> 
> I may have missed this on lkml but are there any on-going community
> efforts to power aware scheduling?
> 
Well, mostly targeting load-balancing, which I gather is kinda useless
for android seeing that it runs on UP hardware.

But yeah, both IBM and Intel have contributed significant work in this
area.

