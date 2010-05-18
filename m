Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab0ERIHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 04:07:13 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:49618 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab0ERIHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 04:07:08 -0400
Date: Tue, 18 May 2010 09:07:06 +0100
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: Brian Jackson <iggy@theiggy.com>
Cc: virtualization@lists.linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH RFC] virtio_blk: Use blk-iopoll for host->guest notify
Message-ID: <20100518080705.GA2467@stefan-thinkpad.transitives.com>
References: <1273870057-4287-1-git-send-email-stefanha@linux.vnet.ibm.com>
 <201005141730.57158.iggy@theiggy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005141730.57158.iggy@theiggy.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 05:30:56PM -0500, Brian Jackson wrote:
> Any preliminary numbers? latency, throughput, cpu use? What about comparing 
> different "weights"?

I am running benchmarks and will report results when they are in.

Stefan
