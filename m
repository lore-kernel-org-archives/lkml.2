Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab0GXJa5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 05:30:57 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:53653 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079Ab0GXJa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 05:30:56 -0400
Message-ID: <4C4AB2C0.6050300@kernel.dk>
Date: Sat, 24 Jul 2010 11:30:40 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cfq-iosched: don't allow aliased requests to starve others
References: <x49zkxuaymb.fsf@segfault.boston.devel.redhat.com>	<20100723042530.GD11236@redhat.com> <x49pqyejkyo.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49pqyejkyo.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2010 05:07 PM, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
>> Also for my education purposes I was curious to know that why can't
>> we keep aliased requests in the service tree. 
> 
> You know, I dug back through the logs, and I didn't find any mention of
> that.  The anticipatory scheduler used to allow such aliases, but then
> that support was removed in favor of a simpler approach.  So, the reason
> may just be out of convenience.

There's no technical reason why we can't do that, at least it'll work in
the rbtree.

-- 
Jens Axboe

