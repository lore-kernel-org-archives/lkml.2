Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab2BGKDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 05:03:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756691Ab2BGKDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 05:03:46 -0500
Message-ID: <4F30F6D7.8080401@redhat.com>
Date: Tue, 07 Feb 2012 11:03:03 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        James Bottomley <JBottomley@parallels.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 90/91] block: fail SCSI passthrough ioctls on partition
 devices
References: <0635750f5f06ed2ca212b91fcb5c4483@local> <20120205220953.312427771@pcw.home.local> <4F2F0669.3000601@redhat.com> <20120205225314.GF8334@1wt.eu>
In-Reply-To: <20120205225314.GF8334@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2012 11:53 PM, Willy Tarreau wrote:
> Thanks for this report, I missed this patch. I thought the reason for the lack
> of scsi_cmd_blk_ioctl() it was one of the differences between 2.6.27 and 2.6.32,
> so I have adapted the callers I identified to perform the same test as what's
> in scsi_cmd_blk_ioctl().

There were other callers in patch 1/3, most notably virtio-blk, that are 
not in your patch.

  I*think*  I did it correctly, but it would be safer
> to apply the original patch, of course. Now I see the patch (618 in my queue).
> I'll merge it and it will simplify the backport.

Sounds like a plan, thanks!

Paolo
