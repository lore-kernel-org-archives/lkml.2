Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533Ab0HDXuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 19:50:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753900Ab0HDXuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 19:50:51 -0400
Date: Wed, 4 Aug 2010 16:49:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Alexander Gordeev <lasaine@lvk.cs.msu.su>, linux-kernel@vger.kernel.org,
        "Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        john stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCHv3 12/16] ntp: add hardpps implementation
Message-Id: <20100804164930.3c210f02.akpm@linux-foundation.org>
In-Reply-To: <4C59FA21.9060006@caviumnetworks.com>
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
	<358275628c418f5f328adc4a4ea23fc902776566.1280952801.git.lasaine@lvk.cs.msu.su>
	<20100804162630.2cebcb91.akpm@linux-foundation.org>
	<4C59FA21.9060006@caviumnetworks.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Aug 2010 16:39:13 -0700
David Daney <ddaney@caviumnetworks.com> wrote:

> On 08/04/2010 04:26 PM, Andrew Morton wrote:
> > sigh.  The amount of inlining which this patch does is nutty.
> 
> Well one could ask about the rationale behind it all and hope that it 
> wasn't purely gratuitous.
> 

Rationale needs rethinking, because removing every one of those inlines
makes no change at all to the generated code.

