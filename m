Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab0KZQkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 11:40:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:33794 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160Ab0KZQkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 11:40:11 -0500
Message-ID: <4CEFE2AF.2040705@kernel.org>
Date: Fri, 26 Nov 2010 17:39:11 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [thiscpuops upgrade 03/10] percpu: Generic support for this_cpu_add,sub,dec,inc_return
References: <20101123235139.908255844@linux.com> <20101123235157.644134695@linux.com> <4CEFE0E8.5050207@kernel.org> <alpine.DEB.2.00.1011261036520.13524@router.home>
In-Reply-To: <alpine.DEB.2.00.1011261036520.13524@router.home>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 16:39:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2010 05:37 PM, Christoph Lameter wrote:
> On Fri, 26 Nov 2010, Tejun Heo wrote:
> 
>> If we're gonna do __VA_ARGS__, can't we just replace
>> __pcpu_size_call_return()?  Other than that, looks good to me.
> 
> A single parameter would require an empty vaarg list. All single parameter
> invocations would have to specify an empty additional parameter.

Argh... okay.

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
