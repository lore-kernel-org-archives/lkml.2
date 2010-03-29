Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab0C2OJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 10:09:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:58567 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362Ab0C2OJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 10:09:42 -0400
Message-ID: <4BB0B535.9060208@kernel.org>
Date: Mon, 29 Mar 2010 23:12:05 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Peter Zijlstra <peterz@infradead.org>, Valdis.Kletnieks@vt.edu,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] module: encapsulate percpu handling better and record
 percpu_size
References: <24605.1268073053@localhost> <4B963441.40000@kernel.org> <4B976CBA.3070305@kernel.org> <201003291856.20637.rusty@rustcorp.com.au>
In-Reply-To: <201003291856.20637.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 29 Mar 2010 14:08:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2010 05:26 PM, Rusty Russell wrote:
> On Wed, 10 Mar 2010 08:26:10 pm Tejun Heo wrote:
>> Better encapsulate module static percpu area handling so that code
>> outsidef of CONFIG_SMP ifdef doesn't deal with mod->percpu directly
>> and add mod->percpu_size and record percpu_size in it.  Both percpu
>> fields are compiled out on UP.  While at it, mark mod->percpu w/
>> __percpu.
> 
> Nice cleanup.
> 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Great.  Patches are pushed out to linux-next with your and Peter's
ACKs added.  I'll ask Linus to pull it after several days.

Thanks!

-- 
tejun
