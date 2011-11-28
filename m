Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab1K1TMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:12:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59952 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab1K1TMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:12:35 -0500
Message-ID: <4ED3DD1C.9010308@kernel.dk>
Date: Mon, 28 Nov 2011 20:12:28 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
CC: stephenmcameron@gmail.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com, linux-kernel@vger.kernel.org,
        thenzl@redhat.com
Subject: Re: [PATCH 1/2] cciss: Add IRQF_SHARED back in for the non-MSI(X)
 interrupt handler
References: <20111128161442.25472.71410.stgit@beardog.cce.hp.com>
In-Reply-To: <20111128161442.25472.71410.stgit@beardog.cce.hp.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-11-28 17:14, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> IRQF_SHARED is required for older controllers that don't support MSI(X)
> and which may end up sharing an interrupt.
> 
> Also remove deprecated IRQF_DISABLED.

Thanks Stephen, applied this one and 2/2 as well.

-- 
Jens Axboe

