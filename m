Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab2AMHRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 02:17:01 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60318 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab2AMHRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 02:17:00 -0500
Message-ID: <4F0FDA59.1050809@kernel.dk>
Date: Fri, 13 Jan 2012 08:16:41 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH] blockdev: convert some macros to static inlines
References: <20120112144215.595112f06f35d0072d5a334e@canb.auug.org.au> <yq1y5tdh8bu.fsf@sermon.lab.mkp.net> <4F0E96C6.9060404@kernel.dk> <yq1y5tcf9cc.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1y5tcf9cc.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2012 06:41 AM, Martin K. Petersen wrote:
>>>>>> "Jens" == Jens Axboe <axboe@kernel.dk> writes:
> \
> Jens> I'll take Stephens if you don't mind, I prefer the simplicity of
> Jens> just typing out the functions.
> 
> Stephen's patch only converted half the stubs. Here's the rest...

Thanks, applied!

-- 
Jens Axboe

