Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab0HCEdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 00:33:18 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58890 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab0HCEdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 00:33:15 -0400
Message-ID: <4C579BFA.40302@cs.helsinki.fi>
Date: Tue, 03 Aug 2010 07:32:58 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
        Nick Piggin <npiggin@suse.de>
Subject: Re: [S+Q2 07/19] slub: Allow removal of slab caches during boot
References: <20100709190706.938177313@quilx.com>  <20100709190853.770833931@quilx.com>  <alpine.DEB.2.00.1007141647340.29110@chino.kir.corp.google.com> <1279498030.10390.1760.camel@pasglop> <alpine.DEB.2.00.1007191058220.29361@router.home> <4C53EFBA.4090900@cs.helsinki.fi> <alpine.DEB.2.00.1008021036210.18455@router.home>
In-Reply-To: <alpine.DEB.2.00.1008021036210.18455@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Sat, 31 Jul 2010, Pekka Enberg wrote:
> 
>> Christoph, Ben, should I queue this up for 2.6.36?
> 
> Yes.

Applied, thanks!
