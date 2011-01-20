Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab1ATI0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 03:26:48 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:33660 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754662Ab1ATI0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 03:26:47 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 20 Jan 2011 09:26:40 +0100
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linux Input <linux-input@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Input: input-polldev - create workqueue upfront
Message-ID: <20110120082640.GA10195@polaris.bitmath.org>
References: <20110120074215.GB30522@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110120074215.GB30522@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1Pfpql-0001wN-53.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1Pfpql-0001wN-53 6dbed1b777fe2a544afba0038297faf3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 11:42:15PM -0800, Dmitry Torokhov wrote:
> Input: input-polldev - create workqueue upfront
> 
> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> With introduction of concurrency-managed work queues there is no point
> in creating workqueues on demand; they can be created upfront as it does
> not cause creation of unused threads.
> 
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---

Looks like a nice cleanup to me.

Henrik
