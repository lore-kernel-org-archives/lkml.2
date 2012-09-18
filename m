Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819Ab2IRJ5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 05:57:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46111 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757708Ab2IRJ5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 05:57:41 -0400
Message-ID: <5058457E.9010706@kernel.dk>
Date: Tue, 18 Sep 2012 11:57:18 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
CC: stephenmcameron@gmail.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com, linux-kernel@vger.kernel.org,
        thenzl@redhat.com
Subject: Re: [PATCH] cciss: fix handling of protocol error
References: <20120914213510.12067.52801.stgit@beardog.cce.hp.com>
In-Reply-To: <20120914213510.12067.52801.stgit@beardog.cce.hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2012 11:35 PM, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> If a command completes with a status of CMD_PROTOCOL_ERR, this
> information should be conveyed to the SCSI mid layer, not dropped
> on the floor.  Unlike a similar bug in the hpsa driver, this bug
> only affects tape drives and CD and DVD ROM drives in the cciss
> driver, and to induce it, you have to disconnect (or damage) a
> cable, so it is not a very likely scenario (which would explain
> why the bug has gone undetected for the last 10 years.)

Thanks Stephen, applied.

-- 
Jens Axboe

