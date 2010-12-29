Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab0L2Vaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 16:30:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56377 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524Ab0L2Vai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 16:30:38 -0500
Message-ID: <4D1BA867.4070105@zytor.com>
Date: Wed, 29 Dec 2010 13:30:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Christoph Lameter <cl@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86: Use this_cpu_ops to optimize code
References: <4D0CD337.4080407@kernel.org> <4D100400.7060104@zytor.com>
In-Reply-To: <4D100400.7060104@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2010 05:33 PM, H. Peter Anvin wrote:
> On 12/18/2010 07:28 AM, Tejun Heo wrote:
>> Peter, these three patches are the x86 ones which were in
>> percpu#for-next but should go through x86 tree.  These should be
>> applied on top of percpu#this_cpu_ops.
> 
> Does that mean the latter is now a stable base that I can pull into -tip?
> 

Hi Tejun,

I talked this over with Ingo, and Ingo is really unhappy about making
-tip depend on the percpu tree ... he says "there are enough problems
with keeping the dependencies working as it is".  As such, it would be
better if you could take these patches in the percpu tree, with my ack.

	-hpa
