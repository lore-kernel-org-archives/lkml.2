Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966024Ab2DLUSE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 16:18:04 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:35410 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487Ab2DLUSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 16:18:02 -0400
Message-ID: <4F873876.4010505@garzik.org>
Date: Thu, 12 Apr 2012 16:17:58 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Ren Mingxin <renmx@cn.fujitsu.com>, Jens Axboe <axboe@kernel.dk>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        LKML <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        VIRTUAL <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 4/4] virtio_blk: use disk_name_format() to support mass
 of disks naming
References: <4F7581D4.4040301@cn.fujitsu.com> <4F7582B0.5010609@cn.fujitsu.com> <20120330152606.GB28934@google.com>
In-Reply-To: <20120330152606.GB28934@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2012 11:26 AM, Tejun Heo wrote:
> If we're gonna move it to block layer, let's add big blinking red
> comment saying "don't ever use it for any new driver".

Big ACK to that...

