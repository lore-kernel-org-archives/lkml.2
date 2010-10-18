Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731Ab0JRTzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:55:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757446Ab0JRTzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:55:51 -0400
Date: Mon, 18 Oct 2010 12:55:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        LKML-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/1] cciss: fix PCI IDs for new Smart Array controllers
Message-Id: <20101018125545.908d97d4.akpm@linux-foundation.org>
In-Reply-To: <20101018185307.GA11223@beardog.cce.hp.com>
References: <20101018185307.GA11223@beardog.cce.hp.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010 13:53:07 -0500
Mike Miller <mike.miller@hp.com> wrote:

> Patch 1 of 1
> cciss: fix PCI IDs for new controllers
> 
> This patch fixes the botched up PCI IDs of new controllers. Please consider
> this patch for inclusion.
> 

What was botched up about it?

What are the runtime effects of this change?
