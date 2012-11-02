Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933316Ab2KBRq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:46:28 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:6669 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932882Ab2KBRqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:46:25 -0400
Date: Fri, 2 Nov 2012 17:46:24 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Shan Wei <shanwei88@gmail.com>
cc: steffen.klassert@secunet.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 5/9] kernel: padata : use this_cpu_read per-cpu
 helper
In-Reply-To: <5093EE63.5000005@gmail.com>
Message-ID: <0000013ac23b18d9-09a4a129-7762-44ea-9445-827a6223f25a-000000@email.amazonses.com>
References: <5093EE63.5000005@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2012, Shan Wei wrote:

> -	queue = per_cpu_ptr(pd->pqueue, smp_processor_id());
> -	if (queue->cpu_index == next_queue->cpu_index) {
> +	if (this_cpu_read(pd->pqueue->cpu_index) == next_queue->cpu_index) {
>  		padata = ERR_PTR(-ENODATA);

Reviewed-by: Christoph Lameter <cl@linux.com>

