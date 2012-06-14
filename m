Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab2FNNWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:22:00 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35191 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab2FNNV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:21:58 -0400
Message-ID: <4FD9E572.4000800@suse.cz>
Date: Thu, 14 Jun 2012 15:21:54 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120608 Thunderbird/14.0
MIME-Version: 1.0
To: Asias He <asias@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: NULL pointer dereference at blk_drain_queue
References: <4FD9A908.90307@suse.cz> <4FD9ABFE.8060603@kernel.dk> <4FD9B1F7.1040107@suse.cz> <4FD9E508.8090405@redhat.com>
In-Reply-To: <4FD9E508.8090405@redhat.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2012 03:20 PM, Asias He wrote:
> On 06/14/2012 05:42 PM, Jiri Slaby wrote:
>> On 06/14/2012 11:16 AM, Jens Axboe wrote:
>>> On 06/14/2012 11:04 AM, Jiri Slaby wrote:
>>>> with today's -next I'm (reproducibly) getting this while updating
>>>> packages:
...
> Jiri, good to hear this fixes for you. BTW. How do you trigger this issue?

On opensuse factory, by zypper dup. It always died at the point of
updating udev or multipath package.

regards,
-- 
js
suse labs
