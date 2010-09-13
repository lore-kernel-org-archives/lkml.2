Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab0IMO4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 10:56:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:41215 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab0IMOz6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 10:55:58 -0400
Subject: Re: [PATCH] perf_events: fix NULL point in free_event()
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com
In-Reply-To: <4c8e3766.991ce30a.32cd.fffff5f0@mx.google.com>
References: <4c8e3766.991ce30a.32cd.fffff5f0@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Sep 2010 16:55:46 +0200
Message-ID: <1284389746.2275.312.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 16:36 +0200, Stephane Eranian wrote:
> Without the following patch, perf top as non-root and
> paranoid cpu set causes a NULL pointer dereference in
> free_event() because event->ctx is NULL.

Yeah, its already on its way.. Cyrill also reported this.
