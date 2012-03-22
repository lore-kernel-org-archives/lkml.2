Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030855Ab2CVUeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 16:34:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33921 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965074Ab2CVUeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 16:34:10 -0400
Message-ID: <4F6B8CB6.1040305@kernel.dk>
Date: Thu, 22 Mar 2012 21:33:58 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
CC: stephenmcameron@gmail.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com, linux-kernel@vger.kernel.org,
        thenzl@redhat.com
Subject: Re: [PATCH 1/2] cciss: Fix scsi tape io with more than 255 scatter
 gather elements
References: <20120322180852.14453.3206.stgit@beardog.cce.hp.com>
In-Reply-To: <20120322180852.14453.3206.stgit@beardog.cce.hp.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-03-22 19:08, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> The total number of scatter gather elements in the CISS command
> used by the scsi tape code was being cast to a u8, which can hold
> at most 255 scatter gather elements.  It should have been cast to
> a u16.  Without this patch the command gets rejected by the controller
> since the total scatter gather count did not add up to the right
> value resulting in an i/o error.

Thanks Stephen, applied both patches.

-- 
Jens Axboe

