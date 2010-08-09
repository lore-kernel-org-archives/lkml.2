Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab0HIPv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 11:51:27 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45690 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab0HIPv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 11:51:26 -0400
Message-ID: <4C6023EC.10001@cs.helsinki.fi>
Date: Mon, 09 Aug 2010 18:51:08 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Christoph Lameter <cl@linux-foundation.org>,
        Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: add missing __percpu markup in mm/slub_def.h
References: <1281119187-12640-4-git-send-email-namhyung@gmail.com> <4C5D51A2.8030306@kernel.org>
In-Reply-To: <4C5D51A2.8030306@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> From: Namhyung Kim <namhyung@gmail.com>
> 
> kmem_cache->cpu_slab is a percpu pointer but was missing __percpu
> markup.  Add it.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> ---
> Christoph, Pekka, can you please route this through slab tree?

Applied, thanks!
