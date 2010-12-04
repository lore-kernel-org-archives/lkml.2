Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab0LDT3M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 14:29:12 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49568 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab0LDT3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 14:29:12 -0500
Message-ID: <4CFA9685.20200@cs.helsinki.fi>
Date: Sat, 04 Dec 2010 21:29:09 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [rfc: cpuops adv V1 0/8] Cmpxchg and xchg support for cpu ops
References: <20101202215340.562309713@linux.com>
In-Reply-To: <20101202215340.562309713@linux.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[ Sorry for the delay everyone. ]

Christoph, do you mind sending me a series that you think is stable 
enough for linux-next? The numbers are pretty impressive and I'd love to 
give them some testing locally and in linux-next.

How should we coordinate the per-CPU ops patches, btw? We had pretty 
good experience with the per-cpu allocator patches where Tejun merged 
the patches in his tree and I pulled it in slab.git. Who handles the 
per-cpu ops?

             Pekka
