Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759520Ab0HDXj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 19:39:27 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:12985 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab0HDXjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 19:39:23 -0400
Message-ID: <4C59FA21.9060006@caviumnetworks.com>
Date: Wed, 04 Aug 2010 16:39:13 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alexander Gordeev <lasaine@lvk.cs.msu.su>, linux-kernel@vger.kernel.org,
        "Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        john stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCHv3 12/16] ntp: add hardpps implementation
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su>	<358275628c418f5f328adc4a4ea23fc902776566.1280952801.git.lasaine@lvk.cs.msu.su> <20100804162630.2cebcb91.akpm@linux-foundation.org>
In-Reply-To: <20100804162630.2cebcb91.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Aug 2010 23:39:18.0483 (UTC) FILETIME=[41A78A30:01CB342E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2010 04:26 PM, Andrew Morton wrote:
> sigh.  The amount of inlining which this patch does is nutty.

Well one could ask about the rationale behind it all and hope that it 
wasn't purely gratuitous.

David Daney

>
> But I don't think I'll bother making a fuss over it.

