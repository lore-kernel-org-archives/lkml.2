Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab1BOQGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 11:06:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755157Ab1BOQGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 11:06:04 -0500
Message-ID: <4D5AA45C.7050600@redhat.com>
Date: Tue, 15 Feb 2011 17:05:48 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Alasdair G Kergon <agk@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Tao Ma <tm@tao.ma>,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH][RFC] dm: Do not open log and cow device read-write
 for read-only mappings
References: <4D5A6EF4.3030905@redhat.com> <20110215124629.GF5825@agk-dp.fab.redhat.com> <20110215152033.GK3160@htj.dyndns.org> <20110215154625.GG5825@agk-dp.fab.redhat.com> <20110215155018.GM3160@htj.dyndns.org>
In-Reply-To: <20110215155018.GM3160@htj.dyndns.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2011 04:50 PM, Tejun Heo wrote:
>> That's why I'm arguing EACCES is not a good error to return and EROFS is
>> more appropriate.
> 
> Frankly, I don't really mind one way or the other but EROFS isn't
> usually used in those areas.  It might make sense for this use case
> and then there will be cases it just feels awkward.  This being a dm
> thing, wouldn't it be just better to let dm massage the return value?

It is not DM thing. That code was checking for generic block device.
No DM there (it was from cryptsetup code but not related to DM part).

Yes, code is not perfect but it worked for >5 years. How many userspace
programs it breaks now?

Milan
