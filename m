Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab0KZPop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:44:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:55536 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648Ab0KZPoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:44:44 -0500
Message-ID: <4CEFD5AF.9060401@kernel.org>
Date: Fri, 26 Nov 2010 16:43:43 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [thiscpuops upgrade 01/10] percpucounter: Optimize __percpu_counter_add
 a bit through the use of this_cpu() options.
References: <20101123235139.908255844@linux.com> <20101123235156.482244613@linux.com>
In-Reply-To: <20101123235156.482244613@linux.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 15:43:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2010 12:51 AM, Christoph Lameter wrote:
> The this_cpu_* options can be used to optimize __percpu_counter_add a bit. Avoids
> some address arithmetic and saves 12 bytes.
...
> Signed-off-by: Christoph Lameter <cl@linux.com>

Reviewed-by: Tejun Heo <tj@kernel.org>

-- 
tejun
