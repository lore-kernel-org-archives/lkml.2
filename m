Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab0L3SVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 13:21:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56419 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812Ab0L3SVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 13:21:22 -0500
Message-ID: <4D1CCD48.5000702@zytor.com>
Date: Thu, 30 Dec 2010 10:19:52 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Christoph Lameter <cl@linux.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: x86: Use this_cpu_has for thermal_interrupt
References: <4D07A7CB.7010205@zytor.com> <4D07A95C.7030703@kernel.org> <4D0814AF.7080209@zytor.com> <4D08ECEF.3040909@kernel.org> <4D08EE57.8010602@zytor.com> <4D08EF4E.8070403@kernel.org> <4D0A3AF2.50508@gmail.com> <alpine.DEB.2.00.1012161212130.21588@router.home> <4D0CD4C6.5010309@gmail.com> <4D0FFB33.8020309@zytor.com> <20101230112933.GB18831@htj.dyndns.org>
In-Reply-To: <20101230112933.GB18831@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2010 03:29 AM, Tejun Heo wrote:
> On Mon, Dec 20, 2010 at 04:56:19PM -0800, H. Peter Anvin wrote:
>> On 12/18/2010 07:35 AM, Tejun Heo wrote:
>>> On 12/16/2010 07:13 PM, Christoph Lameter wrote:
>>>> It is more effective to use a segment prefix instead of calculating the
>>>> address of the current cpu area amd then testing flags.
>>>>
>>>> Signed-off-by: Christoph Lameter <cl@linux.com>
>>>
>>> For this and the other x86 patch.
>>>
>>> Acked-by: Tejun Heo <tj@kernel.org>
>>>
>>> I suppose these two x86 patches and the gameport one would go through
>>> the x86 tree, right?
>>>
>>
>> Yes, as long as I can get a stable base to pull into -tip.
> 
> I suppose I should take the two x86 and the gameport patches here into
> percpu tree with your ACKs too.  Would that be okay with you?
> 

Yes, please.

Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

