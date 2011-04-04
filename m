Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab1DDQUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 12:20:48 -0400
Received: from ist.d-labs.de ([213.239.218.44]:58124 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab1DDQUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 12:20:47 -0400
Date: Mon, 4 Apr 2011 18:20:03 +0200
From: Florian Mickler <florian@mickler.org>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, oliver@neukum.org,
        linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [media] dib0700: get rid of on-stack dma buffers
Message-ID: <20110404182003.163aa519@schatten.dmk.lab>
In-Reply-To: <alpine.LRH.2.00.1104040940000.31158@pub1.ifh.de>
References: <1301851423-21969-1-git-send-email-florian@mickler.org>
	<alpine.LRH.2.00.1104040940000.31158@pub1.ifh.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Apr 2011 09:42:04 +0200 (CEST)
Patrick Boettcher <pboettcher@kernellabs.com> wrote:

> For this one we implemented an alternative. See here:
> 
> http://git.linuxtv.org/pb/media_tree.git?a=commit;h=16b54de2d8b46e48c5c8bdf9b350eac04e8f6b46
> 
> which I pushed, but obviously forgot to send the pull-request.
> 
> This is done now.

Thanks for the information. I see there is a CC: Florian Mickler in
there, but I didn't get any email... maybe something wrong on your
side? 

It helps a lot with closing bug reports in the bugzilla, if people add a
reference to the bugreport - if there is one . I.e. a line:

"This should address bug XXXXX. "

Or even a link (preferred). 

Regards,
Flo

> 
> For the second patch I will incorperate it as soon as I find the time.

no probs. 

> 
> best regards,
> --
> 
> Patrick

