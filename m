Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab0LGOAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 09:00:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:33241 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab0LGOAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 09:00:40 -0500
Message-ID: <4CFE3DC8.8080302@kernel.org>
Date: Tue, 07 Dec 2010 14:59:36 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [Use cpuops V1 01/11] percpucounter: Optimize __percpu_counter_add
 a bit through the use of this_cpu() options.
References: <20101206171618.302060721@linux.com> <20101206171636.862558712@linux.com>
In-Reply-To: <20101206171636.862558712@linux.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Dec 2010 13:59:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2010 06:16 PM, Christoph Lameter wrote:
> The this_cpu_* options can be used to optimize __percpu_counter_add a bit. Avoids
> some address arithmetic and saves 12 bytes.
...
> 
> Reviewed-by: Pekka Enberg <penberg@kernel.org>
> Reviewed-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Signed-off-by: Christoph Lameter <cl@linux.com>

applied to percpu#for-next.

Thanks.

-- 
tejun
