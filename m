Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493Ab0FWKXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:23:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:52884 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab0FWKXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:23:04 -0400
Message-ID: <4C21E07E.40003@kernel.org>
Date: Wed, 23 Jun 2010 12:22:54 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] percpu: add percpu_variable_ptr()
References: <4C21DC33.6070404@cn.fujitsu.com> <4C21DCFF.5050604@kernel.org> <4C21DFDD.9030107@cn.fujitsu.com>
In-Reply-To: <4C21DFDD.9030107@cn.fujitsu.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Jun 2010 10:22:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/23/2010 12:20 PM, Lai Jiangshan wrote:
>> Why not just use &name?
> 
> I remember the real variable name is hidden.
> We can't expose the inner details of percpu, so I add a macro for it.

Yeah, the whole point was unifying static and dynamic ones into the
same name / address space.  &name is now guaranteed to work, so no
need for indirection layer.

Thanks.

-- 
tejun
