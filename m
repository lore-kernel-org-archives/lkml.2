Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467Ab0HDX2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 19:28:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759431Ab0HDX2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 19:28:18 -0400
Date: Wed, 4 Aug 2010 16:26:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V\. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Rodolfo Giometti <giometti@enneenne.com>,
        john stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCHv3 12/16] ntp: add hardpps implementation
Message-Id: <20100804162630.2cebcb91.akpm@linux-foundation.org>
In-Reply-To: <358275628c418f5f328adc4a4ea23fc902776566.1280952801.git.lasaine@lvk.cs.msu.su>
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
	<358275628c418f5f328adc4a4ea23fc902776566.1280952801.git.lasaine@lvk.cs.msu.su>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sigh.  The amount of inlining which this patch does is nutty.

But I don't think I'll bother making a fuss over it.
