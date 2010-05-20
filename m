Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab0ETRpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 13:45:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35859 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751084Ab0ETRpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 13:45:51 -0400
Date: Thu, 20 May 2010 10:42:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
In-Reply-To: <20100520083732.GI25951@kernel.dk>
Message-ID: <alpine.LFD.2.00.1005201041320.23538@i5.linux-foundation.org>
References: <E1OEmP5-0006GU-KC@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.1005190946540.23538@i5.linux-foundation.org> <20100519180554.GY25951@kernel.dk> <20100519190510.GZ25951@kernel.dk> <E1OF1C0-0007mV-VZ@pomaz-ex.szeredi.hu>
 <20100520083732.GI25951@kernel.dk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 20 May 2010, Jens Axboe wrote:
> 
> The main reason I didn't push it before is that I wasn't completely sure
> that we wanted to use fcntl() for this. But Linus doesn't seem to object
> on that side at least.

Well, I don't object as long as there is some real use-case. If it's a 
"feature just for the sake of the feature" kind of theoretical "shouldn't 
we be able to do this" thing, I don't think we should do it.

But it sounded like Miklos actually had a reason for the request. 

		Linus
