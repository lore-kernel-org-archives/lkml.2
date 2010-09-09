Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab0IIJ6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 05:58:15 -0400
Received: from www.tglx.de ([62.245.132.106]:41020 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab0IIJ6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 05:58:13 -0400
Date: Thu, 9 Sep 2010 11:58:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Cochran <richardcochran@gmail.com>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH 0/2] [RFC] posix clock tuning
In-Reply-To: <cover.1283504065.git.richard.cochran@omicron.at>
Message-ID: <alpine.LFD.2.00.1009091152300.2477@localhost6.localdomain6>
References: <cover.1283504065.git.richard.cochran@omicron.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Sep 2010, Richard Cochran wrote:

> Recently on the lkml, we discussed how to allow adjustment of posix
> clocks. I have tried to understand and implement the ideas expressed
> in the various threads.

Cc'ing the relevant maintainers to such discussions and patches might
be helpful. Seems I need to do some archive digging.

> If there is agreement on this approach, I will resubmit these two
> patches as part of a longer series, including support for a new kind
> of hardware clock, so you can see how it all fits together. But first,
> I would like to concentrate on the new syscall itself.
> 
> The patches are against a recent net-next tree. Please don't worry if
> the syscall tables are not quite up to date. I can fix that later.

How is this related to net-next ? 

Thanks,

	tglx
