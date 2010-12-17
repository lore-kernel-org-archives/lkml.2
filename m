Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab0LQPWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 10:22:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:41744 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721Ab0LQPWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:22:42 -0500
Message-ID: <4D0B8023.1070009@kernel.org>
Date: Fri, 17 Dec 2010 16:22:11 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg V2 2/5] x86: this_cpu_cmpxchg and this_cpu_xchg
 operations
References: <20101214162842.542421046@linux.com> <20101214162853.636123666@linux.com>
In-Reply-To: <20101214162853.636123666@linux.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 17 Dec 2010 15:22:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2010 05:28 PM, Christoph Lameter wrote:
> Provide support as far as the hardware capabilities of the x86 cpus
> allow.
> 
> Define CONFIG_CMPXCHG_LOCAL in Kconfig.cpu to allow core code to test for
> fast cpuops implementations.
> 
> V1->V2:
> 	- Take out the definition for this_cpu_cmpxchg_8 and move it into
> 	  a separate patch.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

I reorderd ops so that it follow the organization better.  I'll soon
post the updated patch.  Thanks.

-- 
tejun
