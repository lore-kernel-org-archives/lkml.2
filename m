Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab0IHK2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 06:28:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:47895 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959Ab0IHK2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 06:28:52 -0400
Message-ID: <4C876558.4050301@kernel.org>
Date: Wed, 08 Sep 2010 12:28:40 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [2.6.36-rc3] Workqueues, XFS, dependencies and deadlocks
References: <20100907072954.GM705@dastard> <4C86003B.6090706@kernel.org> <20100907100108.GN705@dastard> <4C861582.6080102@kernel.org> <20100907124850.GP705@dastard> <4C865CC4.9070701@kernel.org> <20100908073428.GR705@dastard> <4C87474B.3050405@kernel.org> <20100908082819.GV705@dastard> <4C874D55.6080402@kernel.org> <20100908101222.GY705@dastard>
In-Reply-To: <20100908101222.GY705@dastard>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Sep 2010 10:28:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/08/2010 12:12 PM, Dave Chinner wrote:
> Ok, so in this case if this was on CPU 1, I'd see kworker[1:0],
> kworker[1:1] and kworker[1:2] threads all accumulate CPU time?  I'm
> just trying to relate your example it to behaviour I've seen to
> check if I understand the example correctly.

Yes, you're right.  If all three works just burn CPU cycles for 5ms
then you'll only see one kworker w/ 15ms of accumulated CPU time.

Thanks.

-- 
tejun
