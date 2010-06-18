Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772Ab0FRJGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 05:06:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:57391 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756281Ab0FRJGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 05:06:05 -0400
Message-ID: <4C1B36F8.9000907@kernel.org>
Date: Fri, 18 Jun 2010 11:06:00 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: michal.svoboda@agents.felk.cvut.cz, linux-kernel@vger.kernel.org
Subject: Re: Very slow disk speed after "IRQ: nobody cared"
References: <20100615092818.GF1635@myhost.felk.cvut.cz> <4C18BB0B.4050100@kernel.org> <20100618050519.GO1635@myhost.felk.cvut.cz>
In-Reply-To: <20100618050519.GO1635@myhost.felk.cvut.cz>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Jun 2010 09:06:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2010 07:05 AM, Michal Svoboda wrote:
> Tejun Heo wrote:
>> Can you please post full boot log?
> 
> Yes, see below.
> 
>> Also, can you give a shot at the following git tree?
> 
> Is that a kernel branch?

Yeah, it's devel tree for better spurious/lost interrupt workaround.

> There are some obstacles. First, it's a production system, I can't
> experiment with swapping kernels too much. If I had a lead on a
> solution I would need to confirm that it worked/didn't work. Which
> is the second obstacle. The problem seems to appear at random with a
> very low frequency. I don't know how to reliably reproduce it. Do
> you have any advice on these?

Unfortunately, I can't think of an easy way to test and verify it.

Thanks.

-- 
tejun
