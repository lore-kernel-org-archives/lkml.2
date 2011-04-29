Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815Ab1D2I2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 04:28:07 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:32977 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757594Ab1D2I2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 04:28:03 -0400
Message-ID: <4DBA7691.4010806@kernel.dk>
Date: Fri, 29 Apr 2011 10:28:01 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Amit Shah <amit.shah@redhat.com>, David Zeuthen <zeuthen@gmail.com>,
        Martin Pitt <martin.pitt@ubuntu.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cdrom: always check_disk_change() on open
References: <20110406121920.GC4142@mtj.dyndns.org> <20110429060200.GA5107@amit-x200.redhat.com> <4DBA73B6.6040603@kernel.dk> <20110429081653.GI16552@htj.dyndns.org>
In-Reply-To: <20110429081653.GI16552@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-29 10:16, Tejun Heo wrote:
> On Fri, Apr 29, 2011 at 10:15:50AM +0200, Jens Axboe wrote:
>>> Also, please mark this for stable-2.6.38.
>>
>> Done, added for 2.6.39 and marked stable for 2.6.38.
> 
> Heh, mid-air collision.  Good morning, Jens. :)

Indeed :-)

-- 
Jens Axboe

