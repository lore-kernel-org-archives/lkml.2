Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab1GFNlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 09:41:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:51193 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab1GFNlS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 09:41:18 -0400
Subject: Re: [PATCH RFC 1/2] cfq: request-deadline policy
From: Peter Zijlstra <peterz@infradead.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>
In-Reply-To: <20110704130838.27757.87486.stgit@localhost6>
References: <20110704130838.27757.87486.stgit@localhost6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 06 Jul 2011 15:41:06 +0200
Message-ID: <1309959666.3282.275.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-04 at 17:08 +0400, Konstantin Khlebnikov wrote:
> This patch implements fifo requests dispatching with deadline policy: now cfq
> obliged to dispatch request if it stuck in the queue for more than deadline.

Have you considered BFQ (http://lkml.org/lkml/2008/11/11/148) which is
WF2Q+ variant?
