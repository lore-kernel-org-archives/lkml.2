Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab0LHQqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 11:46:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:38115 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608Ab0LHQqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 11:46:22 -0500
Message-ID: <4CFFB642.6000207@kernel.org>
Date: Wed, 08 Dec 2010 17:45:54 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops inc_return V1 3/9] x86: Use this_cpu_inc_return for nmi
 counter
References: <20101206173958.685460926@linux.com> <20101206174014.806809612@linux.com>
In-Reply-To: <20101206174014.806809612@linux.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Dec 2010 16:45:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2010 06:40 PM, Christoph Lameter wrote:
> this_cpu_inc_return() saves us a memory access there.
> 
> Reviewed-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Pekka Enberg <penberg@kernel.org>
> Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Signed-off-by: Christoph Lameter <cl@linux.com>

03-05, the updated 06, 07-09 and the connector patch applied and
pushed out to percpu#for-next.

Thanks.

-- 
tejun
