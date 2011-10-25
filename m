Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933519Ab1JYNpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 09:45:15 -0400
Received: from brick.kernel.dk ([87.104.106.3]:50102 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933466Ab1JYNpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 09:45:14 -0400
Message-ID: <4EA6BD63.5080800@kernel.dk>
Date: Tue, 25 Oct 2011 15:45:07 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "tj@kernel.org" <tj@kernel.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] blk-throttle: Free up policy node associated with
 deleted rule
References: <1319144906-5066-1-git-send-email-vgoyal@redhat.com> <20111025133625.GA23292@redhat.com>
In-Reply-To: <20111025133625.GA23292@redhat.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-25 15:36, Vivek Goyal wrote:
> On Thu, Oct 20, 2011 at 05:08:25PM -0400, Vivek Goyal wrote:
>> If a rule is being deleted, free up associated policy node. Otherwise
>> that memory is leaked.
>>
>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> 
> Hi Jens,
> 
> Do you see any issues with the two patches. Can you please consider these
> for merging.

They are in, thanks.

-- 
Jens Axboe

