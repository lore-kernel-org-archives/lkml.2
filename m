Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab1ISQmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 12:42:25 -0400
Received: from mx2.parallels.com ([64.131.90.16]:54291 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756727Ab1ISQmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 12:42:24 -0400
Message-ID: <4E7770BD.6050902@parallels.com>
Date: Mon, 19 Sep 2011 13:41:33 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, <xemul@parallels.com>,
        <paul@paulmenage.org>, <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <mingo@elte.hu>, <jbottomley@parallels.com>
Subject: Re: [PATCH 1/9] Remove parent field in cpuacct cgroup
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>    <1316030695-19826-2-git-send-email-glommer@parallels.com>   <1316448186.1511.19.camel@twins> <4E776937.1070108@parallels.com>  <1316449160.6091.5.camel@twins> <4E776E36.6040906@parallels.com> <1316450385.6091.9.camel@twins>
In-Reply-To: <1316450385.6091.9.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.106.51.14]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2011 01:39 PM, Peter Zijlstra wrote:
> On Mon, 2011-09-19 at 13:30 -0300, Glauber Costa wrote:
>> Since this value is at least intended to
>> provide a basis for cpu capping in the near future (Well, it is not
>> there, but I think it is), it is expected to be used much more
>> frequently by the kernel itself.
>
> We just merged a bandwidth limiter quite separate from cpuacct.

Note I was talking about cpuusage. Well, in this case, I myself fail
to see the value of the whole cpuusage thing... Someone that sees 
further could maybe help us out here? (but this is sideways to the whole 
discussion we're having anyway)
