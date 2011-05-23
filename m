Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab1EWIEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 04:04:45 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:47485 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485Ab1EWIEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 04:04:43 -0400
Message-ID: <4DDA151A.1020504@kernel.dk>
Date: Mon, 23 May 2011 10:04:42 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, dpshah@google.com, namhyung@gmail.com
Subject: Re: [PATCH 0/3] block: Per cpu merge stats and cfq fix
References: <1305936167-8932-1-git-send-email-vgoyal@redhat.com> <20110521000650.GA8026@redhat.com>
In-Reply-To: <20110521000650.GA8026@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-21 02:06, Vivek Goyal wrote:
> On Fri, May 20, 2011 at 08:02:44PM -0400, Vivek Goyal wrote:
>> Hi Jens,
>>
>> Here is the patch for making merge stats per cpu. While scanning the code
>> I also noticed that in one case I was not freeing up per cpu stats. First
>> patch fixes it. I also included Namhyung Kim's bio merge fix.
>>
>> Thanks
>> Vivek
>>
>> Vivek Goyal (3):
>>   cfq-iosched: Fix a memory leak of per cpu stats for root group
>>   cfq-iosched: Make IO merge related stats per cpu
> 
> Minor correction. Following patch author is Namhyung Kim.
> 
> Namhyung Kim(1)

Ugh, already merged it. I should have noticed that too, sorry about that
Namhyung.

-- 
Jens Axboe

