Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587Ab2CBJtK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 04:49:10 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40609 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345Ab2CBJtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 04:49:08 -0500
Message-ID: <4F509785.5090308@kernel.dk>
Date: Fri, 02 Mar 2012 10:48:53 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Danny Kukawka <danny.kukawka@bisect.de>
CC: Tejun Heo <tj@kernel.org>, Danny Kukawka <dkukawka@suse.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH 0/2] drivers/block/DAC960: fix some compiler warnings
References: <1329926681-6057-1-git-send-email-danny.kukawka@bisect.de>
In-Reply-To: <1329926681-6057-1-git-send-email-danny.kukawka@bisect.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2012 05:04 PM, Danny Kukawka wrote:
> Two patches for DAC960. Please add to 3.3.
> 
> Please note: I didn't touch the code style/indentation of the file.

Thanks, applied.

-- 
Jens Axboe

