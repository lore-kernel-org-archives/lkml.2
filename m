Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434Ab0K0UaP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 15:30:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:38553 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab0K0UaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 15:30:12 -0500
Message-ID: <4CF16A4E.106@kernel.org>
Date: Sat, 27 Nov 2010 21:30:06 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>
CC: Christoph Hellwig <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET] backing-dev: replace private thread pool with   workqueue
References: <1283777182-11426-1-git-send-email-tj@kernel.org> <20100907121608.GA26597@lst.de> <4C862DDC.6010702@kernel.org> <4C86303A.90601@fusionio.com> <4C8631BE.9030709@kernel.org> <4CF12BAB.3000704@kernel.org> <4CF152F4.6060400@fusionio.com>
In-Reply-To: <4CF152F4.6060400@fusionio.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 27 Nov 2010 20:30:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/27/2010 07:50 PM, Jens Axboe wrote:
>> cmwq now seems pretty solid.  There hasn't been any noticeable failure
>> yet.  I think we can move on with this conversion now.  Shall I
>> refresh the patchset against the current block tree?
> 
> I'd still prefer to wait a while. The writeback code is still very much
> a moving target, so I don't think mixing in a different work queue
> scheme is likely going to do anyone any good at this point in time.

Alright, will ping again after the next merge window.

Thanks.

-- 
tejun
