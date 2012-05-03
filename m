Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab2ECKwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 06:52:24 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41370 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab2ECKwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 06:52:23 -0400
Date: Thu, 3 May 2012 13:52:11 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Anton Vorontsov <anton.vorontsov@linaro.org>
cc: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH v4] vmevent: Implement greater-than attribute state and
 one-shot mode
In-Reply-To: <20120501131806.GA22249@lizard>
Message-ID: <alpine.LFD.2.02.1205031351470.11258@tux.localdomain>
References: <20120418083208.GA24904@lizard> <20120418083523.GB31556@lizard> <alpine.LFD.2.02.1204182259580.11868@tux.localdomain> <20120418224629.GA22150@lizard> <alpine.LFD.2.02.1204190841290.1704@tux.localdomain> <20120419162923.GA26630@lizard>
 <20120501131806.GA22249@lizard>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2012, Anton Vorontsov wrote:
> This patch implements a new event type, it will trigger whenever a
> value becomes greater than user-specified threshold, it complements
> the 'less-then' trigger type.
> 
> Also, let's implement the one-shot mode for the events, when set,
> userspace will only receive one notification per crossing the
> boundaries.
> 
> Now when both LT and GT are set on the same level, the event type
> works as a cross event type: it triggers whenever a value crosses
> the threshold from a lesser values side to a greater values side,
> and vice versa.
> 
> We use the event types in an userspace low-memory killer: we get a
> notification when memory becomes low, so we start freeing memory by
> killing unneeded processes, and we get notification when memory hits
> the threshold from another side, so we know that we freed enough of
> memory.
> 
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

Applied, thanks!
