Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab1FNFtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 01:49:19 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51889 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab1FNFtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 01:49:15 -0400
Message-ID: <4DF6F659.3000109@cs.helsinki.fi>
Date: Tue, 14 Jun 2011 08:49:13 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
        tj@kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu
Subject: Re: [slubllv7 04/17] x86: Add support for cmpxchg_double
References: <20110601172543.437240675@linux.com> <20110601172614.173427964@linux.com> <4DF09827.7070809@cs.helsinki.fi> <alpine.DEB.2.00.1106101016420.30968@router.home> <BANLkTikHOsvR-KXZ-VQvpAaMgrNOR0sB3g@mail.gmail.com> <alpine.DEB.2.00.1106111202110.32170@router.home>
In-Reply-To: <alpine.DEB.2.00.1106111202110.32170@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/11 8:02 PM, Christoph Lameter wrote:
> On Sat, 11 Jun 2011, Pekka Enberg wrote:
>
>> Oh, I don't know - but I definitely need more ACKs to even consider
>> pushing this through slab.git.
>
> Any additional ackers out there?;-)

Ingo, ping? Could we have this in -tip so I can pull from there? This is 
blocking me from queuing SLUB performance improvements to linux-next.

			Pekka
