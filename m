Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933144Ab0LUA5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 19:57:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46151 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754388Ab0LUA53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 19:57:29 -0500
Message-ID: <4D0FFB33.8020309@zytor.com>
Date: Mon, 20 Dec 2010 16:56:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Christoph Lameter <cl@linux.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: x86: Use this_cpu_has for thermal_interrupt
References: <20101214162842.542421046@linux.com>  <20101214162855.392020353@linux.com> <1292345072.5934.32.camel@edumazet-laptop> <alpine.DEB.2.00.1012141055220.17229@router.home> <4D07A2B7.8080405@zytor.com> <alpine.DEB.2.00.1012141109470.17229@router.home> <4D07A7CB.7010205@zytor.com> <4D07A95C.7030703@kernel.org> <4D0814AF.7080209@zytor.com> <4D08ECEF.3040909@kernel.org> <4D08EE57.8010602@zytor.com> <4D08EF4E.8070403@kernel.org> <4D0A3AF2.50508@gmail.com> <alpine.DEB.2.00.1012161212130.21588@router.home> <4D0CD4C6.5010309@gmail.com>
In-Reply-To: <4D0CD4C6.5010309@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2010 07:35 AM, Tejun Heo wrote:
> On 12/16/2010 07:13 PM, Christoph Lameter wrote:
>> It is more effective to use a segment prefix instead of calculating the
>> address of the current cpu area amd then testing flags.
>>
>> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> For this and the other x86 patch.
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> I suppose these two x86 patches and the gameport one would go through
> the x86 tree, right?
> 

Yes, as long as I can get a stable base to pull into -tip.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

